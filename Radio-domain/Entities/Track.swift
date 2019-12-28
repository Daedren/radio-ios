import Foundation

public struct Track {
    public var title: String
    public var artist: String
    
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
        self.title = title
        self.artist = artist
        self.startTime = startTime
        self.endTime = endTime
        self.requested = requested
    }
}
