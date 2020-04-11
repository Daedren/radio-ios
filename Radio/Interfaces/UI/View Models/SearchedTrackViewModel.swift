import Foundation
import Radio_Domain


struct SearchedTrackViewModel: Identifiable {
    var id: Int?
    var title: String
    var artist: String
//    var lastPlayed: Date?
    var lastRequested: String?
    var state: SearchTrackState = .requestable
    
    init(from entity: SearchedTrack) {
        self.title = entity.title
        self.artist = entity.artist
        if let requestable = entity.requestable {
            self.state = requestable ? .requestable : .notRequestable
        }
        self.id = entity.id
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }
    
    init(from entity: FavoriteTrack) {
        self.title = entity.title
        self.artist = entity.artist
        self.id = entity.id
        self.state = .notRequestable
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }
    
    static func stub() -> SearchedTrackViewModel {
        let track = SearchedTrack(id: 5917,
                                  title: "Pray",
                                  artist: "Nana Mizuki",
                                  lastPlayed: Date(),
                                  lastRequested: Date(),
                                  requestable: true)
        return SearchedTrackViewModel(from: track)
    }
}
