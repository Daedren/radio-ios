import Foundation
import Swinject
import Radio_Domain
import Radio_data

class MapperConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
    }
}
