import Foundation
import Swinject
import Radio_Domain

class InterfaceConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(NetworkClient.self) { _ in
            return URLSessionClient()
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
