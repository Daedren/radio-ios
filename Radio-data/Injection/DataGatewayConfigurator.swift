import Foundation
import Swinject
import Radio_domain
import Radio_cross

public class DataGatewayConfigurator: Assembly {
    public init() {}
    public func assemble(container: Container) {
        
        container.register(RadioGateway.self) { _ in
            return RadioGatewayImp(
                network: container.resolve(NetworkDispatcher.self, name: "real")!,
                radioMapper: container.resolve(RadioMapper.self)!,
                logger: container.resolve(LoggerWrapper.self)!
            )
        }
        
        container.register(NetworkClient.self) { _ in
            return URLSessionClient(logger: container.resolve(LoggerWrapper.self)!)
        }
        container.register(RadioRequestHandler.self) { _ in
            return RadioRequestHandler(baseSchemeAndAuthority: URL(string: "https://r-a-d.io/")!)
        }
        container.register(RadioResponseHandler.self) { _ in
            return RadioResponseHandler()
        }
        
        container.register(NetworkDispatcher.self, name: "fake") { _ in
            return FakeNetworkClient()
        }
        container.register(NetworkDispatcher.self, name: "real") { _ in
            return RadioNetworkManager(request: container.resolve(RadioRequestHandler.self)!,
                                       response: container.resolve(RadioResponseHandler.self)!,
                                       client: container.resolve(NetworkClient.self)!)
        }
    }
}
