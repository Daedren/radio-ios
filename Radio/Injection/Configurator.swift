import Foundation
import Swinject
import Radio_Domain
import Radio_cross
import Radio_data

protocol Configurator {

}

extension Configurator {
    var assembler: Assembler {
        if let singleton = Assembler.sharedInstance {
            return singleton
        } else {
            let newAssembler = Assembler([
                              CrossConfigurator(),
                              InterfaceConfigurator(),
                              MapperConfigurator(),
                              DataGatewayConfigurator(),
                              iOSGatewayConfigurator(),
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
