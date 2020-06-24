import Foundation

public class RadioDetailedModel {
    public var status: RadioStatus
    public var dj: RadioDJ
    public var currentTrack: QueuedTrack
    public var queue: [QueuedTrack]
    public var lastPlayed: [QueuedTrack]
    
    public init(
        status: RadioStatus,
        dj: RadioDJ,
        currentTrack: QueuedTrack,
        queue: [QueuedTrack],
        lastPlayed: [QueuedTrack]
    ) {
        self.status = status
        self.dj = dj
        self.currentTrack = currentTrack
        self.queue = queue
        self.lastPlayed = lastPlayed
    }
}
