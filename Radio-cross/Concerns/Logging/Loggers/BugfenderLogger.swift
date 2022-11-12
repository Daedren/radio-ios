import Foundation
import BugfenderSDK

public class BugfenderLogger: LoggerClientInterface {
    let level: LoggingLevel
    var loggers = [String: String]()

    public init(loggingLevel: LoggingLevel) {
        self.level = loggingLevel
        Bugfender.activateLogger("")
        //Bugfender.enableCrashReporting()
        //Bugfender.enableUIEventLogging()  // optional, log user interactions automatically
    }

    public func log(message: String, context: String, logLevel: LoggingLevel, function: String, line: Int) {
        let location = "<\(function)@L\(line)>"
        let messageWithInfo = "\(location) \(message)"

        bfprint(messageWithInfo, tag: context, level: logLevel.getBFLogLevel())
    }
}

private extension LoggingLevel {
    func getBFLogLevel() -> BFLogLevel {
        switch self {
        case .debug:
            return .`default`
        case .error:
            return .error
        case .verbose:
            return .`default`
        case .info, .warning:
            return .info
        }
    }
}
