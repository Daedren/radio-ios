import Foundation
import Radio_domain
import Radio_data


public struct SearchedTrackViewModel: Identifiable, Equatable, ButtonViewModel {
    public var id: Int
    var externalId: Int?
    var title: String
    var artist: String
    //    var lastPlayed: Date?
    var lastRequested: String?
    public var state: ButtonViewModelStatus = .enabled
    
    public var fullText: String {
        "\(artist) - \(title)"
    }
    
    public init(from entity: RequestableTrack, with id: Int) {
        self.title = entity.title
        self.artist = entity.artist
        self.id = id
        if let requestable = entity.requestable {
            self.state = requestable ? .enabled : .disabled
        }
        self.externalId = entity.id
        
        let offset = entity.lastRequested?.offsetFrom(date: Date())
        self.lastRequested = offset ?? ""
    }
    
    public func buttonText(for state: ButtonViewModelStatus) -> String {
        switch state {
        case .enabled:
            return "Request"
        case .disabled:
            return "Request"
        default:
            return ""
        }
    }
    
    
    public static func stub() -> SearchedTrackViewModel {
        let track = SearchedTrack(id: 5917,
                                  title: "Pray",
                                  artist: "Nana Mizuki",
                                  lastPlayed: Date(),
                                  lastRequested: Date(),
                                  requestable: true)
        return SearchedTrackViewModel(from: track, with: 1)
    }
}
