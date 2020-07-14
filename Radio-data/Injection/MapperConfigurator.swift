import Foundation
import Swinject
import Radio_domain

public class MapperConfigurator: Assembly {
    public init() {}
    public func assemble(container: Container) {
        
        container.register(RadioMapper.self) { _ in
            return RadioMapperImp()
        }
    }
}
