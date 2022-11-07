import Foundation

public protocol RequestableTrack: Track {

    var id: Int? { get set }
    var title: String { get set }
    var artist: String { get set }

    var lastRequested: Date? { get set }
    var lastPlayed: Date? { get set }
    
    var requestable: Bool? { get set }
}
