import Foundation
import Swinject
import Radio_domain
import Radio_data
import Radio_cross
import Radio_app

class iOSInterfaceConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(HTMLParser.self) { _ in
            return DataHTMLParser()
        }
        
        container.register(MusicGateway.self) { _ in
            let client = AVClient(logger: container.resolve(LoggerWrapper.self)!)
            return MusicRepository(logger: container.resolve(LoggerWrapper.self)!, client: client)
        }
        
//        container.register(AVGateway.self) { _ in
//            let client = FSClient(logger: container.resolve(LoggerWrapper.self)!)
//            return AVGatewayImp(logger: container.resolve(LoggerWrapper.self)!, client: client)
//        }
        
    }
}
