import Foundation
import Radio_Domain


struct SearchedTrackViewModel: Identifiable, RequestButtonViewModel {
    var id: Int
    var externalId: Int?
    var title: String
    var artist: String
    //    var lastPlayed: Date?
    var lastRequested: String?
    var state: SearchTrackState = .requestable
    
    init(from entity: SearchedTrack, with id: Int) {
        self.title = entity.title
        self.artist = entity.artist
        self.id = id
        if let requestable = entity.requestable {
            self.state = requestable ? .requestable : .notRequestable
        }
        self.externalId = entity.id
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }
    
    init(from entity: FavoriteTrack, with id: Int) {
        self.title = entity.title
        self.artist = entity.artist
        self.externalId = entity.id
        self.id = id
        self.state = .notRequestable
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }
    
    func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Request"
        case .loading:
            return ""
        case .notRequestable:
            return "Requestable soon"
        }
    }
    
    
    static func stub() -> SearchedTrackViewModel {
        let track = SearchedTrack(id: 5917,
                                  title: "Pray",
                                  artist: "Nana Mizuki",
                                  lastPlayed: Date(),
                                  lastRequested: Date(),
                                  requestable: true)
        return SearchedTrackViewModel(from: track, with: 1)
    }
}
