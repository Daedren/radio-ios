import Foundation

public struct RadioStatus {
    var listeners: Int
    var bitrate: Int
    var currentTime: Date
    var acceptingRequests: Bool
    
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
