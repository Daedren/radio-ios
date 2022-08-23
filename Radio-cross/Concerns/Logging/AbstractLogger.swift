import Foundation

public enum LoggingLevel: String {
    case debug = "Debug"
    case warning = "Warning"
    case error = "Error"
    case info = "Info"
    case verbose = "Verbose"
}

/// Actual interfaces that do the logging
public protocol LoggerClientInterface {
    func log(message: String, context: String, logLevel: LoggingLevel, function: String, line: Int)
}

// Logger abstraction, so that we can log to various places.
// Receives logging clients as parameter
public class Logger: Logging {
    let loggers: [LoggerClientInterface]
    
    public init(_ loggers: [LoggerClientInterface]) {
        self.loggers = loggers
    }
    
    public func log(message: String, context: String, logLevel: LoggingLevel, function: String, line: Int) {
        let filename = context.components(separatedBy: "/").last ?? ""
        loggers.forEach { logger in
            logger.log(message: message, context: filename, logLevel: logLevel, function: function, line: line)
        }
    }
}

public protocol Logging {
    func log(message: String, context: String, logLevel: LoggingLevel, function: String, line: Int)
}

public extension Logging {
    func log(message: String, context: String = #file, logLevel: LoggingLevel = .debug, function: String = #function, line: Int = #line) {
        InjectSettings.shared.resolve(Logging.self)?.log(message: message, context: context, logLevel: logLevel, function: function, line: line)
    }
}
