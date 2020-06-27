import Foundation
import Swinject
import Radio_Domain
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
    }
}
