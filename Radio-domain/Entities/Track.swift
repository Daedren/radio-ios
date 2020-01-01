import Foundation

public protocol Track {
    var title: String { get set }
    var artist: String { get set }
}

public struct BaseTrack: Track, Hashable {
    public static func == (lhs: BaseTrack, rhs: BaseTrack) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.title)
    }

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
