import Intents
import Radio_Domain
import Radio_data
import Radio_cross

class IntentHandler: INExtension {
  
  override func handler(for intent: INIntent) -> Any {
    guard intent is QueueIntent else {
      fatalError("Unhandled intent type: \(intent)")
    }
    
    let logger = OSLogLogger(loggingLevel: .error)
    let networkCli = URLSessionClient(configuration: nil, logger: logger)
    let response = RadioResponseHandler()
    let request = RadioRequestHandler(baseSchemeAndAuthority: URL(string: "https://r-a-d.io/")!)
    let network = RadioNetworkManager(request: request, response: response, client: networkCli)
    let mapper = RadioMapperImp()
    let radioGateway = RadioGatewayImp(network: network, radioMapper: mapper, logger: logger)
    let songQueue = GetSongQueueInteractor(radio: radioGateway)
    let updateUseCase = FetchRadioDataInteractor(radioGateway: radioGateway)
    return QueueIntentHandler(queueUseCase: songQueue, updateUseCase: updateUseCase)
  }
  
}
