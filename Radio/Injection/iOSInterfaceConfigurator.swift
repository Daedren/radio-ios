import Foundation
import Radio_cross
import Radio_domain
import Radio_data
import Radio_cross
import Radio_interfaces

class iOSInterfaceConfigurator {
    init() {
        
        InjectSettings.shared.register(HTMLParser.self) {
            return DataHTMLParser()
        }
        
        InjectSettings.shared.register(MusicGateway.self) {
            let client = AVClient(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!)
            return MusicRepository(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!, client: client)
        }
        
//        InjectSettings.shared.register(AVGateway.self) {
//            let client = FSClient(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!)
//            return AVGatewayImp(logger: InjectSettings.shared.resolve(LoggerWrapper.self)!, client: client)
//        }
        
    }
}
