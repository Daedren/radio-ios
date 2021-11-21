//
//import Foundation
//import Radio_cross
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
//class IntentConfigurator {
//    init() {
//
//        InjectSettings.shared.register(RadioMapper.self) {
//            return RadioMapperImp()
//        }
//    }
//}
