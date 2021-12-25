import Foundation
import Radio_cross
import Radio_domain
import Radio_data

class IntentConfigurator {
    init() {
        InjectSettings.shared = Container()
        CrossConfigurator()
        MapperConfigurator()
        DataGatewayConfigurator()
        InteractorConfigurator()
    }

}
