import Foundation
import Swinject
import Radio_domain
import Radio_data
import Radio_cross

class iOSInterfaceConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(HTMLParser.self) { _ in
            return DataHTMLParser()
        }

    }
}
