import Foundation
import Radio_Domain

struct TrackViewModel: Identifiable {
    var id: String = UUID().uuidString
    
    public var title: String
    public var artist: String
    
    public var startsIn: String
    public var requested: Bool
    
    public init(base: Track) {
        self.title = base.title
        self.artist = base.artist
        self.requested = base.requested
        
        self.startsIn = base.startTime?.offsetFrom(date: Date()) ?? ""
    }
    
    public static func stub() -> TrackViewModel {
        let track = Track(title: "title", artist: "artist", startTime: Date.init(timeIntervalSinceNow: 30.0), endTime: nil, requested: false)
        return TrackViewModel(base: track)
    }
}
