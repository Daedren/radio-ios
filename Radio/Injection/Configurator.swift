import Foundation
import Swinject

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
                              GatewayConfigurator(),
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
