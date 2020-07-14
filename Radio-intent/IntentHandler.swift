import Intents
import Swinject
import Radio_domain

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
    let configurator = IntentConfigurator()
    
    if intent is QueueIntent {
        let songQueue = configurator.assembler.resolver.resolve(GetSongQueueInteractor.self)!
        let updateUseCase = configurator.assembler.resolver.resolve(FetchRadioDataUseCase.self)!
        return QueueIntentHandler(queueUseCase: songQueue, updateUseCase: updateUseCase)
    }
    
    if intent is SearchIntent || intent is INSearchForMediaIntent {
        let songSearch = configurator.assembler.resolver.resolve(SearchForTermInteractor.self)!
        let updateUseCase = configurator.assembler.resolver.resolve(FetchRadioDataUseCase.self)!
        return SearchIntentHandler(searchUseCase: songSearch, updateUseCase: updateUseCase)
    }
    
    fatalError("Unhandled intent type: \(intent)")
    
  }
  
}
