import Foundation

public struct SearchedTrack: Track {
    public var title: String
    public var artist: String
    
    public var lastPlayed: Date?
    public var lastRequested: Date?
    public var requestable: Bool?
    
    public init(title: String, artist: String, lastPlayed: Date?, lastRequested: Date?, requestable: Bool?) {
        self.lastPlayed = lastPlayed
        self.lastRequested = lastRequested
        self.requestable = requestable
        self.title = title
        self.artist = artist

    }

}
