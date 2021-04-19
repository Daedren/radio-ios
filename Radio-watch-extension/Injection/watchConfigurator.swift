import Foundation
import Swinject
import Radio_domain
import Radio_data
import Radio_cross
import Radio_app

class watchConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(AVGateway.self) { _ in
            let client = AVClient(logger: container.resolve(LoggerWrapper.self)!)
            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!, client: client)
        }
        
    }
}
