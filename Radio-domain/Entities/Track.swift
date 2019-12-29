import Foundation

public struct Track {
    public var info: TrackTitleArtist

    public var startTime: Date?
    public var endTime: Date?
    public var requested: Bool
    
    public init(
        title: String,
        artist: String,
        startTime: Date?,
        endTime: Date?,
        requested: Bool
        ) {
        self.info = TrackTitleArtist(title: title, artist: artist)
        self.startTime = startTime
        self.endTime = endTime
        self.requested = requested
    }
}

public struct TrackTitleArtist {
    public var title: String
    public var artist: String
    
    public init(
        title: String,
        artist: String
    ) {
        self.title = title
        self.artist = artist
    }
}
