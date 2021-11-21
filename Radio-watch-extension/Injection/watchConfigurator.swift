import Foundation
import Radio_cross
import Radio_domain
import Radio_data
import Radio_cross
import Radio_interfaces

class watchConfigurator {
    init() {
        InjectSettings.shared.register(MusicGateway.self) {
            let client = AVClient(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!)
            return MusicRepository(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!, client: client)
        }
        
    }
}
