import Foundation
import Radio_cross
import Radio_domain
import Radio_cross
import Radio_data
import Radio_interfaces

protocol Configurator {

}

extension Configurator {
    var assembler: Assembler {
        if let singleton = Assembler.sharedInstance {
            return singleton
        } else {
            let newAssembler = Assembler([
                              CrossConfigurator(),
                              MapperConfigurator(),
                              DataGatewayConfigurator(),
//                              SharedAppInterfaceConfigurator(),
                              InteractorConfigurator()
                ], parent: nil,
                   defaultObjectScope: .container)
            Assembler.sharedInstance = newAssembler
            return newAssembler
        }
    }
}

extension Assembler {
    static var sharedInstance: Assembler?
}
