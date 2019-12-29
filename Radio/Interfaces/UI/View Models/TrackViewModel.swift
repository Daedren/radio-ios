import Foundation
import Radio_Domain

class TrackViewModel: Identifiable {
    var id: String = UUID().uuidString
    
    public var title: String
    public var artist: String
    
    public var startsIn: String
    public var endsAt: String
    public var requested: Bool
    
    public init(base: Track) {
        self.title = base.info.title
        self.artist = base.info.artist
        self.requested = base.requested
        
        self.startsIn = base.startTime?.offsetFrom(date: Date()) ?? ""
        if let endTime = base.endTime {
            self.endsAt = Date().offsetFrom(date: endTime)
        }
        else {
            self.endsAt = ""
        }
    }
    
    public static func stub() -> TrackViewModel {
        let track = Track(title: "title", artist: "artist", startTime: Date.init(timeIntervalSinceNow: 30.0), endTime: Date.init(timeIntervalSinceNow: 30.0), requested: false)
        return TrackViewModel(base: track)
    }
}
