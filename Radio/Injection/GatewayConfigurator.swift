import Foundation
import Swinject
import Radio_Domain

class GatewayConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(AVGateway.self) { _ in
            return AVGatewayImp()
        }
    }
}
