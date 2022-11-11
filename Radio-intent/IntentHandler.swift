import Intents
import Radio_cross
import Radio_domain

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
    let configurator = IntentConfigurator()
    
    if intent is QueueIntent {
        let songQueue = InjectSettings.shared.resolve(GetSongQueueInteractor.self)!
        let updateUseCase = InjectSettings.shared.resolve(FetchRadioDataUseCase.self)!
        return QueueIntentHandler(queueUseCase: songQueue, updateUseCase: updateUseCase)
    }
    
    if intent is SearchIntent || intent is INSearchForMediaIntent {
        let songSearch = InjectSettings.shared.resolve(SearchForTermUseCase.self)!
        return SearchIntentHandler(searchUseCase: songSearch)
    }

      if intent is RandomFaveIntent {
        let updateUseCase = InjectSettings.shared.resolve(FetchRadioDataUseCase.self)!
        let songSearch = InjectSettings.shared.resolve(GetFavoritesInteractor.self)!
        let getUsername = InjectSettings.shared.resolve(GetLastFavoriteUserUseCase.self)!
        let request = InjectSettings.shared.resolve(RequestSongUseCase.self)!
        return RandomFaveIntentHandler(
        updateUseCase: updateUseCase,
        getUsernameUseCase: getUsername,
        requestUseCase: request,
        searchUseCase: songSearch)
    }

    fatalError("Unhandled intent type: \(intent)")
    
  }
  
}
