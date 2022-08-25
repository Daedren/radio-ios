import Foundation
import Radio_domain
import Radio_cross
import Combine
import Intents

class RandomFaveIntentHandler: NSObject, RandomFaveIntentHandling {
    
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
    
    
  func confirm(intent: RandomFaveIntent, completion: @escaping (RandomFaveIntentResponse) -> Void) {
    completion(RandomFaveIntentResponse(code: .ready, userActivity: nil))

  }
  
  func handle(intent: RandomFaveIntent, completion: @escaping (RandomFaveIntentResponse) -> Void) {
      completion(RandomFaveIntentResponse(code: .failure, userActivity: nil))
  }
    
}
