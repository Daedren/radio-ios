import Foundation

public struct RadioStatus {
    public var listeners: Int
    public var bitrate: Int
    public var currentTime: Date
    public var acceptingRequests: Bool
    
    public init(
        listeners: Int,
        bitrate: Int,
        currentTime: Date,
        acceptingRequests: Bool
    )
    {
        self.listeners = listeners
        self.bitrate = bitrate
        self.currentTime = currentTime
        self.acceptingRequests = acceptingRequests
    }
}
