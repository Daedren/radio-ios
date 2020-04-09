import Foundation
import Swinject
import Radio_Domain
import Radio_cross

class CrossConfigurator: Assembly {
    func assemble(container: Container) {
        
        container.register(LoggerWrapper.self) { _ in
            return OSLogLogger(loggingLevel: .error)
        }

    }
}
