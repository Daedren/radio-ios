import Foundation
import Radio_domain

public class CurrentTrackViewModel: TrackViewModel {
    public var trackBackup: QueuedTrack?
    public var currentDate: Date?
    public var startDate: Date?
    public var endDate: Date?
    
    public var percentage: Double?
    public var startTag: String?
    public var endTag: String?
    public var tags: String = ""
    
    override public init(base: QueuedTrack) {
        super.init(base: base)
        self.trackBackup = base
        self.setCurrentTrackVars(current: base.currentTime, start: base.startTime, end: base.endTime, tags: base.tags)
    }
    
    override func equalTo(rhs: TrackViewModel) -> Bool {
        guard let rhs = rhs as? CurrentTrackViewModel else { return false }
        return self.title == rhs.title &&
            self.artist == rhs.artist &&
            self.currentDate == rhs.currentDate
    }
    
//    static func == (lhs: CurrentTrackViewModel, rhs: CurrentTrackViewModel) -> Bool {
//        lhs.title == rhs.title &&
//            lhs.artist == rhs.artist &&
//            lhs.currentDate == rhs.currentDate
//    }
    
    private func setCurrentTrackVars(current: Date?, start: Date?, end: Date?, tags: [String] = []) {
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

            self.tags = tags.joined(separator: ", ")
        }
    }
    
    public func updateCurrentTime(_ newTime: Date) {
        self.setCurrentTrackVars(current: newTime,
                                 start: self.startDate,
                                 end: self.endDate)
    }
    
    public static func stubCurrent() -> CurrentTrackViewModel {
        let track = QueuedTrack(title: "Beyond the BLADE (IGNITED arrangement)",
                                artist: "Mizuki Nana",
                                startTime: Date.init(timeIntervalSince1970: 1577622501),
                                endTime: Date.init(timeIntervalSince1970: 1577622752),
                                currentTime: Date.init(timeIntervalSince1970: 1577622606),
                                requested: false,
                                tags: ["nana wills it", "Symphogear"])
        return CurrentTrackViewModel(base: track)
    }
}
