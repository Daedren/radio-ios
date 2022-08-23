import Foundation
import Combine

public protocol ToggleSleepTimerUseCase {
    /// Sending a null date will disable the sleep timer.
    func execute(at: Date?)
}

public class ToggleSleepTimerInteractor: ToggleSleepTimerUseCase {
    let sleepGateway: SleepGateway

    public init(sleepGateway: SleepGateway) {
        self.sleepGateway = sleepGateway
    }
    
    public func execute(at date: Date?) {
        self.sleepGateway.toggleSleepTimer(at: date)
    }
}
