import Foundation

public struct FavoriteTrack: Track, Hashable {
    public var id: Int?
    public var title: String
    public var artist: String
    
    public var lastRequested: Date?
    public var lastPlayed: Date?
    public var requestCount: Int?
    
    public var requestable: Bool? = false

    public init(id: Int?, title: String, artist: String, lastPlayed: Date?, lastRequested: Date?, requestCount: Int?) {
        self.id = id
        self.lastPlayed = lastPlayed
        self.lastRequested = lastRequested
        self.title = title
        self.artist = artist
        self.requestCount = requestCount
    }
}
