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
    
    queueUseCase
        .execute()
        .filter{ !$0.isEmpty }
        .first()
        .handleEvents(receiveSubscription: { _ in
//            completion(QueueIntentResponse(code: .inProgress, userActivity: nil))
        })
        .first()
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { tracks in
            let intentTracks = tracks.map{ track -> IntentTrack in
                let startTime = track.startTime?.offsetFrom(date: Date())
                let startText = startTime != nil ? " (in \(startTime ?? ""))" : ""
                let intTrack = IntentTrack(identifier: track.title, display: "\(track.artist) - \(track.title)\(startText)")
                intTrack.artist = track.artist
                intTrack.title = track.title
                intTrack.time = startTime
                return intTrack
            }
            completion(QueueIntentResponse.success(tracks: intentTracks))
        })
        .store(in: &queueDisposeBag)
  }
}
