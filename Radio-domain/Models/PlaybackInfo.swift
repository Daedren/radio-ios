
import Foundation

public struct PlaybackInfo {
    public var rate: Float
    public var duration: Float? = nil
    public var position: Float
    
    public init(rate: Float = 1.0, duration: Float? = nil, position: Float) {
        self.rate = rate
        self.duration = duration
        self.position = position
    }
}
