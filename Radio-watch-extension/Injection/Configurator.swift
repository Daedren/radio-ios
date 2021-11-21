import Foundation
import Radio_cross
import Radio_domain
import Radio_data
import Radio_interfaces

class Configurator {
    init() {
        InjectSettings.shared = Container()
        WatchConfigurator()
        CrossConfigurator()
        MapperConfigurator()
        DataGatewayConfigurator()
        //                              SharedAppInterfaceConfigurator(),
        InteractorConfigurator()
    }
}
