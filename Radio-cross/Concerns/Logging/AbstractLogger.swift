import Foundation

/// App logger level set in an environment variable or similar.
public enum AbstractLoggerLevel: String {
    case debug = "Debug"
    case warning = "Warning"
    case error = "Error"
    case info = "Info"
    case verbose = "Verbose"
}

/// Logger instance to be used in the individual modules
public protocol AbstractLogger {
    func loggerDebug(message: String)
    func loggerWarning(message: String)
    func loggerError(message: String)
    func loggerInfo(message: String)
    func loggerVerbose(message: String)
}

/// Main logger instance that actually executes the log.
public protocol LoggerWrapper: Component {
    func debug(message: String, context: String)
    func warning(message: String, context: String)
    func error(message: String, context: String)
    func info(message: String, context: String)
    func verbose(message: String, context: String)
}

public class LoggerAggregator: LoggerWrapper {
    let loggers: [LoggerWrapper]
    
    public init(loggers: [LoggerWrapper]) {
        self.loggers = loggers
    }
    
    public func debug(message: String, context: String) {
        loggers.forEach { log in
            log.debug(message: message, context: context)
        }
    }
    
    public func warning(message: String, context: String) {
        loggers.forEach { log in
            log.warning(message: message, context: context)
        }
    }
    
    public func error(message: String, context: String) {
        loggers.forEach { log in
            log.error(message: message, context: context)
        }
    }
    
    public func info(message: String, context: String) {
        loggers.forEach { log in
            log.info(message: message, context: context)
        }
    }
    
    public func verbose(message: String, context: String) {
        loggers.forEach { log in
            log.verbose(message: message, context: context)
        }
    }
        
}

public protocol LoggerWithContext: AbstractLogger {
    var context: String { get }
    var loggerInstance: LoggerWrapper { get set }
}

extension LoggerWithContext {
    public var context: String {
        return String(describing: type(of: self))
    }
    
    public func loggerDebug(message: String) {
        loggerInstance.debug(message: message, context: self.context)
    }
    public func loggerWarning(message: String) {
        loggerInstance.warning(message: message, context: self.context)
    }
    public func loggerInfo(message: String) {
        loggerInstance.info(message: message, context: self.context)
    }
    public func loggerError(message: String) {
        loggerInstance.error(message: message, context: self.context)
    }
    public func loggerVerbose(message: String) {
        loggerInstance.verbose(message: message, context: self.context)
    }
}
