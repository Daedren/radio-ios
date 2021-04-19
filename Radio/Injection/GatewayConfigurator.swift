import Foundation
import Swinject
import Radio_Domain
import Radio_cross

class GatewayConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
        container.register(AVGateway.self) { _ in
            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!,
                                client: container.resolve(AudioClientContract.self, name: "freestreamer")!)
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
