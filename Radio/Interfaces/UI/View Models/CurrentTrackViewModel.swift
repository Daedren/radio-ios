import Foundation
import Radio_Domain

class CurrentTrackViewModel: TrackViewModel {
    public var trackBackup: Track?
    public var currentDate: Date?
    public var startDate: Date?
    public var endDate: Date?
    
    public var percentage: Double?
    public var startTag: String?
    public var endTag: String?

    override public init(base: Track) {
        super.init(base: base)
        self.trackBackup = base
        self.setCurrentTrackVars(current: base.currentTime,start: base.startTime,end: base.endTime)
    }
    
    private func setCurrentTrackVars(current: Date?, start: Date?, end: Date?) {
        if let currentTime = current, let startTime = start, let endTime = end {
            self.currentDate = current
            self.startDate = start
            self.endDate = end
            
            let current = currentTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            let end = endTime.timeIntervalSince1970 - startTime.timeIntervalSince1970
            
            let dayHourMinuteSecond: Set<Calendar.Component> = [.minute, .second]
            let currDiff = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: startTime, to: currentTime);
            let endDiff = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: startTime, to: endTime);
            
            self.percentage = current / end
            if let minute = endDiff.minute, let second = endDiff.second {
                self.endTag = String(format: "%01d:%02d", minute, second)
            }
            if let minute = currDiff.minute, let second = currDiff.second {
                self.startTag = String(format: "%01d:%02d", minute, second)
            }
        }
    }
    
    public func updateCurrentTime(_ newTime: Date) {
        self.setCurrentTrackVars(current: newTime,
                                 start: self.startDate,
                                 end: self.endDate)
    }
    
    public static func stubCurrent() -> CurrentTrackViewModel {
        let track = Track(title: "title",
                          artist: "artist",
                          startTime: Date.init(timeIntervalSince1970: 1577622501),
                          endTime: Date.init(timeIntervalSince1970: 1577622752),
                          currentTime: Date.init(timeIntervalSince1970: 1577622606),
                          requested: false)
        return CurrentTrackViewModel(base: track)
    }
}
