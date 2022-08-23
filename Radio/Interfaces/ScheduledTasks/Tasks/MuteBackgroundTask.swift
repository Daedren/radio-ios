import Foundation
import BackgroundTasks
import Radio_domain

public class MuteBackgroundTask: ScheduledTask {
    public var task: ScheduledTaskType = ScheduledTaskType.stopMusic
    
    let muteMusic: StopRadioUseCase
    
    public init(muteUseCase: StopRadioUseCase) {
        self.muteMusic = muteUseCase
    }
    
    public func handle(task: BGTask? = nil) {
        self.muteMusic.execute()
        task?.setTaskCompleted(success: true)
    }
}
