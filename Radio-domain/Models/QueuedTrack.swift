import Foundation

public struct QueuedTrack: Track, Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    public var title: String
    public var artist: String
    
    public var startTime: Date?
    public var endTime: Date?
    public var currentTime: Date?
    public var requested: Bool

    public init(
        title: String,
        artist: String,
        startTime: Date?,
        endTime: Date?,
        currentTime: Date? = nil,
        requested: Bool
        ) {
        self.startTime = startTime
        self.currentTime = currentTime
        self.endTime = endTime
        self.requested = requested
        self.title = title
        self.artist = artist
    }
}
