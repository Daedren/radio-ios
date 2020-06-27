import Intents
import Swinject
import Radio_Domain

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
    guard intent is QueueIntent,
          let songQueue = Assembler.sharedInstance?.resolver.resolve(GetSongQueueInteractor.self),
          let updateUseCase = Assembler.sharedInstance?.resolver.resolve(FetchRadioDataUseCase.self) else {
      fatalError("Unhandled intent type: \(intent)")
    }
    
    return QueueIntentHandler(queueUseCase: songQueue, updateUseCase: updateUseCase)
  }
  
}
