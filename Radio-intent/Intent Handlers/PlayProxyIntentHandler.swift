import Intents
import MediaPlayer
import Network

// Extension proxy only required for iOS 13.
// iOS 14+ will ask the app directly
class PlayProxyIntentHandler: INExtension, INPlayMediaIntentHandling {
    
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        let monitor = NWPathMonitor()
        
        if monitor.currentPath.status == .satisfied {
            let stationItem = INMediaItem(identifier: "radiostation", title: "R/a/dio", type: .musicStation, artwork: nil, artist: nil)
            completion(INPlayMediaMediaItemResolutionResult.successes(with: [stationItem]))
        } else {
            completion([INPlayMediaMediaItemResolutionResult.unsupported(forReason: .cellularDataSettings)])
        }
    }
    
    func handle(intent: INPlayMediaIntent, completion: (INPlayMediaIntentResponse) -> Void) {
        completion(INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil))
    }
    
}
