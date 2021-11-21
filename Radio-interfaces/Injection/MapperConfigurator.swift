import Foundation
import Radio_cross
import Radio_domain

public class MapperConfigurator {
    public init() {
        
        InjectSettings.shared.register(RadioMapper.self) {
            return RadioMapperImp()
        }
    }
}
