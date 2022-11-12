import Foundation
import OSLog

private extension LoggingLevel {
    func getOSLogLevel() -> OSLogType {
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

public class OSLogLogger: LoggerClientInterface {
    let level: LoggingLevel
    var loggers = [String:OSLog]()
    
    public init(loggingLevel: LoggingLevel) {
        self.level = loggingLevel
    }
    
    public func log(message: String, context: String, logLevel: LoggingLevel, function: String, line: Int) {
        let logger = self.getLogger(category: context)
        let location = "<\(function)@L\(line)>"
        let messageWithInfo = "\(location) \(message)"

        os_log("%{PUBLIC}@", log: logger, type: logLevel.getOSLogLevel(), messageWithInfo)
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
