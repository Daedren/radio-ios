import Foundation
import Swinject
import Radio_domain
import Radio_cross

public class SharedAppInterfaceConfigurator: Assembly {
    public init() {}
    public func assemble(container: Container) {
        
        container.register(AVGateway.self) { _ in
            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!)
        }
    }
}
