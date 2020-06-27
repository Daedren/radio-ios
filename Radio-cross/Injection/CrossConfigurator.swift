import Foundation
import Swinject

public class CrossConfigurator: Assembly {
    public init() {}
    public func assemble(container: Container) {
        
        container.register(LoggerWrapper.self) { _ in
            return OSLogLogger(loggingLevel: .error)
        }

    }
}
