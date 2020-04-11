import Foundation

public protocol Track {
    var title: String { get set }
    var artist: String { get set }
}

extension Track where Self: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(artist) - \(title)")
    }
}

public class BaseTrack: Track, Hashable {
    public static func == (lhs: BaseTrack, rhs: BaseTrack) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine("\(artist) - \(title)")
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
