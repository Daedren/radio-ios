import Foundation
import Radio_domain
import Radio_cross

public class DataGatewayConfigurator {
    public init() {
        
        InjectSettings.shared.register(NetworkClient.self) {
            return URLSessionClient()
        }
        InjectSettings.shared.register(RadioRequestHandler.self) {
            return RadioRequestHandler(baseSchemeAndAuthority: URL(string: "https://r-a-d.io/")!)
        }
        InjectSettings.shared.register(RadioResponseHandler.self) {
            return RadioResponseHandler()
        }
        
        InjectSettings.shared.register(NetworkDispatcher.self, name: "fake") {
            return FakeNetworkClient()
        }
        InjectSettings.shared.register(NetworkDispatcher.self, name: "real") {
            return RadioNetworkManager(request: InjectSettings.shared.resolve(RadioRequestHandler.self)!,
                                       response: InjectSettings.shared.resolve(RadioResponseHandler.self)!,
                                       client: InjectSettings.shared.resolve(NetworkClient.self)!)
        }
        
        InjectSettings.shared.register(RadioGateway.self) {
            return RadioGatewayImp(
                network: InjectSettings.shared.resolve(NetworkDispatcher.self, name: "real")!,
                radioMapper: InjectSettings.shared.resolve(RadioMapper.self)!
            )
        }
        
        InjectSettings.shared.register(PersistenceGateway.self) {
            return PersistenceRepository()
        }
        
    }
}
