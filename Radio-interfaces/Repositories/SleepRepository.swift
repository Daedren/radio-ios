import Foundation
import Radio_cross
import Radio_domain

class SleepRepository: Logging {
    var audioInterface: AudioClientContract
    
    var scheduledTime: Date?
    
    
    public init(audio: AudioClientContract) {
        self.audioInterface = audio
    }
    
    func scheduleStop(for date: Date) {
        self.scheduledTime = date
//       let request = BGAppRefreshTaskRequest(identifier: "cc.raik.r-a-dio.pause")
//       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
//       do {
//          try BGTaskScheduler.shared.submit(request)
//       } catch {
//          print("Could not schedule app refresh: \(error)")
//       }
    }
    
    func removeSchedule() {
        self.scheduledTime = nil
        
    }
    
}
