import Foundation
import Radio_domain
import Radio_interfaces

class SleepRepository: SleepGateway {
    let backgroundService: TaskManager
    
    init(backgroundService: TaskManager) {
        self.backgroundService = backgroundService
    }
    
    func toggleSleepTimer(at date: Date?) {
        if let nonNullDate = date {
            backgroundService.schedule(task: ScheduledTaskType.stopMusic, at: nonNullDate)
        } else {
            backgroundService.cancel(task: ScheduledTaskType.stopMusic)
        }
    }
}
