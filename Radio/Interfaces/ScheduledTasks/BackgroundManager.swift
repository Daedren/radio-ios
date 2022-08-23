import Foundation
import Radio_cross
import BackgroundTasks

public enum ScheduledTaskType: String {
    case stopMusic = ".music.stop"
    
    func getWithUti() -> String {
        return (Bundle.main.bundleIdentifier ?? "") + self.rawValue
    }
}

public protocol ScheduledTask {
    var task: ScheduledTaskType { get }
    func handle(task: BGTask?)
}

public protocol TaskManager {
    func cancel(task: ScheduledTaskType)
    func schedule(task: ScheduledTaskType, at time: Date)
}

public class BackgroundManagerImpl: TaskManager, Logging {
    
    let handlers: [ScheduledTask]
    
    public init(handlers: [ScheduledTask]) {
        self.handlers = handlers
        
        for handler in self.handlers {
            self.register(handler: handler)
        }
    }
    
    public func cancel(task: ScheduledTaskType) {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: task.getWithUti())
    }
    
    public func schedule(task: ScheduledTaskType, at time: Date) {
        let request = BGAppRefreshTaskRequest(identifier: task.getWithUti())
        request.earliestBeginDate = time
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch let err {
            self.log(message: err.localizedDescription, logLevel: .error)
        }
    }
    
    func register(handler: ScheduledTask) {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: handler.task.getWithUti(),
            using: nil, launchHandler: handler.handle(task:))
    }
}
