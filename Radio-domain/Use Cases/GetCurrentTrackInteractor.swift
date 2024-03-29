import Foundation
import Radio_cross
import Combine

public protocol GetCurrentTrackUseCase {
    func execute(with disposeBag: Set<AnyCancellable>) -> AnyPublisher<QueuedTrack,Never>
}

public class GetCurrentTrackInteractor: GetCurrentTrackUseCase, Logging {
    var avGateway: MusicGateway?
    var radioGateway: RadioGateway

    var endSongDisposeBag = Set<AnyCancellable>()

    public init(avGateway: MusicGateway?, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }

    public func execute(with disposeBag: Set<AnyCancellable>) -> AnyPublisher<QueuedTrack, Never>{
        self.endSongDisposeBag = disposeBag

        let apiTrack = self.radioGateway
            .getCurrentTrack()
            .map{ track -> QueuedTrack? in
                return track
            }
            .handleEvents(receiveOutput: { output in
                self.log(message: "api: "+String(describing: output))
            }, receiveCompletion: { completion in
                self.log(message: "api: "+String(describing: completion))
            }, receiveCancel: {
                self.log(message: "api: cancelled")
            })
            .`catch` { err in return Just<QueuedTrack?>(nil) }
            .prepend(Just<QueuedTrack?>(nil))
            .eraseToAnyPublisher()

        let icyName = self.avGateway?.getSongName()
            .prepend(Just<String>(""))
            .handleEvents(receiveOutput: { output in
                self.log(message: "icy: "+String(describing: output))
//                self.songOverHandler()
            }, receiveCompletion: { completion in
                self.log(message: "icy: "+String(describing: completion))
            }, receiveCancel: {
                self.log(message: "icy: cancelled")
            })
            .eraseToAnyPublisher()

        let timer = Timer.publish(every: 1.0,
                                  tolerance: 5.0,
                                  on: .current,
                                  in: .common)
            .autoconnect()
            .eraseToAnyPublisher()

        let mergedObs = apiTrack
            .combineLatest(icyName ?? Just<String>("").eraseToAnyPublisher())
            .flatMap{ [unowned self] (arg) -> AnyPublisher<QueuedTrack,Never> in
                let (api, icy) = arg

                var model: QueuedTrack? = api
                if self.avGateway?.isPlaying() ?? false {
                    self.changeTrackName(to: icy, track: &model)
                }

                if let model = model {
                    return Just(model).eraseToAnyPublisher()
                }
                else {
                    return Empty<QueuedTrack,Never>().eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()

        let mergedObsWithTimer = timer.combineLatest(mergedObs)
            .flatMap{ (arg) -> AnyPublisher<QueuedTrack,Never> in
                var (timer, model) = arg
                model.currentTime = timer
                return Just(model).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
        return mergedObsWithTimer
    }

    private func changeTrackName(to icyName: String, track: inout QueuedTrack?) {
        let split = icyName.components(separatedBy: " - ")
        if split.count == 2,
           let title = split.last,
           let artist = split.first {
            track?.title = title
            track?.artist = artist
        } else {
            track?.title = icyName
            track?.artist = ""
        }
    }

    private func songOverHandler() {
        self.radioGateway.updateNow()
            .replaceError(with: ())
            .sink(receiveValue: { _ in
            })
            .store(in: &endSongDisposeBag)
    }

}
