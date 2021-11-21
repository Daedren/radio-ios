import Intents
import Radio_cross
import Radio_domain

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
//    let configurator = IntentConfigurator()
    
    if intent is QueueIntent {
        let songQueue = InjectSettings.shared.resolve(GetSongQueueInteractor.self)!
        let updateUseCase = InjectSettings.shared.resolve(FetchRadioDataUseCase.self)!
        return QueueIntentHandler(queueUseCase: songQueue, updateUseCase: updateUseCase)
    }
    
    if intent is SearchIntent || intent is INSearchForMediaIntent {
        let songSearch = InjectSettings.shared.resolve(SearchForTermInteractor.self)!
        let updateUseCase = InjectSettings.shared.resolve(FetchRadioDataUseCase.self)!
        return SearchIntentHandler(searchUseCase: songSearch, updateUseCase: updateUseCase)
    }
    
    fatalError("Unhandled intent type: \(intent)")
    
  }
  
}
