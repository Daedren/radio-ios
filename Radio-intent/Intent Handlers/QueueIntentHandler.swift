import Foundation
import Radio_domain
import Radio_cross
import Combine
import Intents

class QueueIntentHandler: NSObject, QueueIntentHandling {
    
    let queueUseCase: GetSongQueueInteractor
    let updateUseCase: FetchRadioDataUseCase
    var queueDisposeBag = Set<AnyCancellable>()
    
    internal init(queueUseCase: GetSongQueueInteractor,
                  updateUseCase: FetchRadioDataUseCase,
                  queueDisposeBag: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.queueUseCase = queueUseCase
        self.updateUseCase = updateUseCase
        self.queueDisposeBag = queueDisposeBag
    }
    
    
    func confirm(intent: QueueIntent, completion: @escaping (QueueIntentResponse) -> Void) {

        completion(QueueIntentResponse(code: .ready, userActivity: nil))

    }

    func handle(intent: QueueIntent, completion: @escaping (QueueIntentResponse) -> Void) {

        updateUseCase.execute(())
            .flatMap{ self.queueUseCase.execute() }
            .print("Memes")
            .first()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure(_):
                    completion(.init(code: .failure, userActivity: nil))
                default:
                    break
                }
            }, receiveValue: { [unowned self] tracks in
                let intentTracks = tracks.map(self.mapTrackToIntentVersion(_:))
                completion(QueueIntentResponse.success(tracks: intentTracks))
            })
            .store(in: &queueDisposeBag)
    }
    
    func mapTrackToIntentVersion(_ track: QueuedTrack) -> IntentTrack {
        let startTime = track.startTime?.offsetFrom(date: Date())
        let startText = startTime != nil ? " (in \(startTime ?? ""))" : ""
        let intTrack = IntentTrack(identifier: track.title, display: "\(track.artist) - \(track.title)\(startText)")
        intTrack.artist = track.artist
        intTrack.title = track.title
        intTrack.time = startTime
        return intTrack
    }
}
