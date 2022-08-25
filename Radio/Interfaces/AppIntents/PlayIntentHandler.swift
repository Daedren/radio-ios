import Intents
import Network
import Radio_domain

class PlayIntentHandler: INExtension, INPlayMediaIntentHandling {
    
    let playUseCase: PlayRadioUseCase
    
    internal init(playUseCase: PlayRadioUseCase) {
        self.playUseCase = playUseCase
    }

    
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
        playUseCase.execute()
        completion(INPlayMediaIntentResponse(code: .success, userActivity: nil))
    }
    
}
