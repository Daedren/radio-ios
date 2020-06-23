import Foundation
import Radio_Domain

class TrackViewModel: Identifiable, Equatable {
    var id: String = UUID().uuidString
    
    public var title: String
    public var artist: String
    
    public var startsIn: String
    public var endsAt: String
    public var requested: Bool
    
    public init(base: QueuedTrack) {
        self.title = base.title
        self.artist = base.artist
        self.requested = base.requested
        
        self.startsIn = base.startTime?.numericOffsetFrom(date: Date()) ?? ""
        if let endTime = base.endTime {
            self.endsAt = Date().offsetFrom(date: endTime)
        }
        else {
            self.endsAt = ""
        }
    }
    
    static func == (lhs: TrackViewModel, rhs: TrackViewModel) -> Bool {
        lhs.equalTo(rhs: rhs)
    }
    
    func equalTo(rhs: TrackViewModel) -> Bool {
        self.title == rhs.title &&
            self.artist == rhs.artist
    }

    public static func stub() -> TrackViewModel {
        let track = QueuedTrack(title: "title", artist: "artist", startTime: Date.init(timeIntervalSinceNow: 30.0), endTime: Date.init(timeIntervalSinceNow: 30.0), requested: false)
        return TrackViewModel(base: track)
    }
}
