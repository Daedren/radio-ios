import Foundation
import Swinject
import Radio_Domain
import Radio_cross
import Radio_data

class GatewayConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
        container.register(AVGateway.self) { _ in
            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!)
        }
        container.register(RadioGateway.self) { _ in
            return RadioGatewayImp(
                network: container.resolve(NetworkDispatcher.self, name: "real")!,
                radioMapper: container.resolve(RadioMapper.self)!,
                logger: container.resolve(LoggerWrapper.self)!
            )
        }
    }
}
