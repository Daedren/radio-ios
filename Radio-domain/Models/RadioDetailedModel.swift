import Foundation
import Radio_Domain

public class RadioDetailedModel {
    var status: RadioStatus
    var dj: RadioDJ
    var currentTrack: Track
    var queue: [Track]
    var lastPlayed: [Track]
    
    init(
        status: RadioStatus,
        dj: RadioDJ,
        currentTrack: Track,
        queue: [Track],
        lastPlayed: [Track]
    ) {
        self.status = status
        self.dj = dj
        self.currentTrack = currentTrack
        self.queue = queue
        self.lastPlayed = lastPlayed
    }
}
