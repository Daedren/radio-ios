import Foundation
import Radio_cross
import Radio_domain
import Radio_cross
import Radio_data
import Radio_interfaces

class Configurator {
    init() {
        CrossConfigurator()
        iOSInterfaceConfigurator()
        MapperConfigurator()
        DataGatewayConfigurator()
        //                              SharedAppInterfaceConfigurator(),
        InteractorConfigurator()
    }
}
