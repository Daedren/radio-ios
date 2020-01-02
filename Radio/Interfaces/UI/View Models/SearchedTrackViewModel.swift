import Foundation
import Radio_Domain

struct SearchedTrackViewModel: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var artist: String
//    var lastPlayed: Date?
    var lastRequested: String
    var requestable: Bool
    
    init(from entity: SearchedTrack) {
        self.title = entity.title
        self.artist = entity.artist
        self.requestable = entity.requestable ?? false
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }

}
