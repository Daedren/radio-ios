import Foundation

// References
// https://github.com/R-a-dio/site/blob/develop/app/start/global.php#L125
// https://github.com/yattoz/Radio2/blob/master/app/src/main/java/io/r_a_d/radio2/ui/songs/request/CooldownCalculator.kt#L50

public struct SongDelayLogic {
    public init() {}
    
    public func isSongUnderCooldown(track: FavoriteTrack) -> Bool {
        if let requestCount = track.requestCount,
           let lastRequested = track.lastRequested?.timeIntervalSince1970,
           let lastPlayed = track.lastPlayed?.timeIntervalSince1970 {
            
            let now = Date().timeIntervalSince1970
            let delay = self.delay(requestCount)
            
            let remainingCooldown = max(lastPlayed, lastRequested) + delay - now
            return remainingCooldown > 0.0
        }
        return true
    }
    
    func delay(_ requestCount: Int) -> Double {
        let priority = min(requestCount, 30)
        var duration: Double = 0.0
        if 0...7 ~= priority {
            duration = -11057 * Double(priority*priority) + 172954 * Double(priority) + 81720
        } else {
            duration = 599955 * exp(0.0372 * Double(priority)) + 0.5
        }
        return duration / 2
    }
    
    
    
}
