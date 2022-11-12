import Foundation

public class CrossConfigurator {
    public init() {
        InjectSettings.shared.register(Logging.self) {
            return Logger([
                OSLogLogger(loggingLevel: .info)
//                BugfenderLogger(loggingLevel: .info)
            ])
        }
        
    }
}

