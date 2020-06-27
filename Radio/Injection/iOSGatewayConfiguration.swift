import Foundation
import Swinject
import Radio_Domain
import Radio_cross

public class iOSGatewayConfigurator: Assembly {
    public init() {}
    public func assemble(container: Container) {
        
        container.register(AVGateway.self) { _ in
            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!)
        }
    }
}
