import Foundation

public struct SearchedTrack: Track {
    public var title: String
    public var artist: String
    public var id: Int
    
    public var lastPlayed: Date?
    public var lastRequested: Date?
    public var requestable: Bool?
    
    public init(id: Int, title: String, artist: String, lastPlayed: Date?, lastRequested: Date?, requestable: Bool?) {
        self.id = id
        self.lastPlayed = lastPlayed
        self.lastRequested = lastRequested
        self.requestable = requestable
        self.title = title
        self.artist = artist

    }

}
