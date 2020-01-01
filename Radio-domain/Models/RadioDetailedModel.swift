import Foundation
import Radio_Domain

public class RadioDetailedModel {
    var status: RadioStatus
    var dj: RadioDJ
    var currentTrack: QueuedTrack
    var queue: [QueuedTrack]
    var lastPlayed: [QueuedTrack]
    
    init(
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
