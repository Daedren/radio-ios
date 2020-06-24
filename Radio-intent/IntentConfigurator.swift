//
//import Foundation
//import Swinject
//
//protocol Configurator {
//
//}
//
//extension Configurator {
//    var assembler: Assembler {
//        if let singleton = Assembler.sharedInstance {
//            return singleton
//        } else {
//            let newAssembler = Assembler([
//                              IntentConfigurator()
//                ], parent: nil,
//                   defaultObjectScope: .container)
//            Assembler.sharedInstance = newAssembler
//            return newAssembler
//        }
//    }
//}
//
//extension Assembler {
//    static var sharedInstance: Assembler?
//}
//
//
//class IntentConfigurator: Assembly {
//    func assemble(container: Container) {
//
//        container.register(RadioMapper.self) { _ in
//            return RadioMapperImp()
//        }
//    }
//}
