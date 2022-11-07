import Foundation

public struct FavoriteTrack: RequestableTrack, Hashable {
    public var id: Int?
    public var title: String
    public var artist: String
    public var lastPlayed: Date?
    public var lastRequested: Date?
    public var requestable: Bool?

    public var requestCount: Int?

    public init(id: Int?, title: String, artist: String, lastPlayed: Date?, lastRequested: Date?, requestCount: Int?) {
        self.id = id
        self.lastPlayed = lastPlayed
        self.lastRequested = lastRequested
        self.title = title
        self.artist = artist
        self.requestCount = requestCount
        self.requestable = false // Currently being set on get. Probably should change that.
    }
}
