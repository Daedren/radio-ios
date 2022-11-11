import Foundation
import Radio_cross
import Radio_domain
import Radio_data
import Radio_cross
import Radio_interfaces

class WatchConfigurator {
    init() {
        InjectSettings.shared.register(MusicGateway.self) {
            let client = AVClient()
            return MusicRepository(client: client)
        }
        
    }
}
