import Foundation
import Radio_cross

public class TimerManagerImpl: TaskManager, Logging {
    
    var handlers: [String: ScheduledTask]
    var timers = [String: Timer]()
    
    public init(handlers: [ScheduledTask]) {
        self.handlers = Dictionary(uniqueKeysWithValues: handlers.map{ ($0.task.rawValue, $0)})
    }
    
    public func cancel(task: ScheduledTaskType) {
        timers[task.rawValue]?.invalidate()
    }
    
    public func schedule(task: ScheduledTaskType, at time: Date) {
        self.log(message: "Scheduling timer", logLevel: .info)
        let timer = Timer.scheduledTimer(withTimeInterval: time.timeIntervalSinceNow, repeats: false) { [weak self] _ in
            self?.handlers[task.rawValue]?.handle(task: nil)
            self?.log(message: "Fired task", logLevel: .info)
        }

        timers[task.rawValue] = timer
        
    }
}
