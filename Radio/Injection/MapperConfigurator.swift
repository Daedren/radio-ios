import Foundation
import Swinject
import Radio_Domain

class MapperConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
    }
}
