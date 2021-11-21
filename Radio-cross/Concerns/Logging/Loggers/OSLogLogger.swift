import Foundation
import os.log

extension AbstractLoggerLevel {
    func getBeaverLogLevel() -> OSLogType {
        switch self {
        case .debug:
            return .debug
        case .error:
            return .error
        case .verbose:
            return .default
        case .info, .warning:
            return .info
        }
    }
}

public class OSLogLogger: LoggerWrapper, Component {
    let level: AbstractLoggerLevel
    var loggers = [String:OSLog]()
    
    public init(loggingLevel: AbstractLoggerLevel) {
        self.level = loggingLevel
    }
    
    public func debug(message: String, context: String) {
        let logger = self.getLogger(category: context)
        os_log("%{PUBLIC}@", log: logger, type: .debug, message)
    }
    
    public func warning(message: String, context: String) {
        let logger = self.getLogger(category: context)
        os_log("%{PUBLIC}@", log: logger, type: .default, message)
    }
    
    public func error(message: String, context: String) {
        let logger = self.getLogger(category: context)
        os_log("%{PUBLIC}@", log: logger, type: .error, message)
    }
    
    public func info(message: String, context: String) {
        let logger = self.getLogger(category: context)
        os_log("%{PUBLIC}@", log: logger, type: .info, message)
    }
    
    public func verbose(message: String, context: String) {
        let logger = self.getLogger(category: context)
        os_log("%{PUBLIC}@", log: logger, type: .debug, message)
    }
    
    func getLogger(category: String) -> OSLog {
        if let log = loggers[category] {
            return log
        } else {
            let log = OSLog(subsystem: Bundle.main.bundleIdentifier ?? "App", category: category)
            loggers[category] = log
            return log
        }
    }
}
