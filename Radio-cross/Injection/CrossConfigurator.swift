import Foundation

public class CrossConfigurator {
    public init() {
        InjectSettings.shared.register(LoggerWrapper.self) {
            OSLogLogger(loggingLevel: .error)
        }
    }
}

