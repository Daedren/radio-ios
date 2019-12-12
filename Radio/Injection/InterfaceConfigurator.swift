import Foundation
import Swinject
import Radio_Domain

class InterfaceConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(NetworkDispatcher.self, name: "fake") { _ in
            return FakeNetworkClient()
        }
//        container.register(NetworkDispatcher.self, name: "real") { _ in
//            return NetworkDispatcher()
//        }

    }
}
