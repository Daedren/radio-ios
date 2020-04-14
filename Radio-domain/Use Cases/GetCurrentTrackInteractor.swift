import Foundation
import Combine

public protocol GetCurrentTrackUseCase {
    func execute() -> AnyPublisher<QueuedTrack,Never>
}

public class GetCurrentTrackInteractor: GetCurrentTrackUseCase {
    var avGateway: AVGateway
    var radioGateway: RadioGateway
    
    var endSongDisposeBag = Set<AnyCancellable>()
    
    public init(avGateway: AVGateway, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }
    
    public func execute() -> AnyPublisher<QueuedTrack, Never>{
        let apiName = self.radioGateway
            .getCurrentTrack()
            .map{ track -> QueuedTrack? in
                return track
        }
        .catch({err in
            return Just<QueuedTrack?>(nil)
        })
            .prepend(Just<QueuedTrack?>(nil))
            .eraseToAnyPublisher()
        
        let icyName = self.avGateway.getSongName()
            //            .removeDuplicates()
            .map{ [unowned self] artistAndName -> QueuedTrack? in
                return self.radioGateway
                    .getTrackWith(identifier: artistAndName)
        }
        .prepend(Just<QueuedTrack?>(nil))
            //            .compactMap{ $0 }
            .eraseToAnyPublisher()
        
        let timer = Timer.publish(every: 1.0, on: .current, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
        
        let mergedObs = apiName
            .combineLatest(icyName)
            .flatMap{ [unowned self] (arg) -> AnyPublisher<QueuedTrack,Never> in
                let (api, icy) = arg
                
                var model: QueuedTrack? = nil
                if self.avGateway.isPlaying() {
                    model = icy
                }
                else  {
                    model = api
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
        
        self.songOverHandler(obs: mergedObsWithTimer)
        
        
        return mergedObsWithTimer
    }
    
    private func songOverHandler(obs: AnyPublisher<QueuedTrack, Never>) {
        obs
            .compactMap{ return $0 }
            .filter{
                if let endTime = $0.endTime,
                    let currentTime = $0.currentTime,
                    endTime > currentTime {
                    return true
                }
                return false
        }
        .removeDuplicates(by: { $0.hashValue == $1.hashValue })
//        .catch{ err in return Empty<QueuedTrack,Never>() }
        .sink(receiveValue: { _ in
            self.radioGateway.updateNow()
        })
            .store(in: &endSongDisposeBag)
    }
    
}
