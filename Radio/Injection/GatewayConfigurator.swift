import Foundation
import Swinject
import Radio_Domain

class GatewayConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
        container.register(AVGateway.self) { _ in
            return AVGatewayImp()
        }
        container.register(RadioGateway.self) { _ in
            return RadioGatewayImp(
                network: container.resolve(NetworkDispatcher.self, name: "real")!,
                radioMapper: container.resolve(RadioMapper.self)!
            )
        }
    }
}
