import Foundation
import Combine

public class GetFavoritesInteractor: Interactor {
    public typealias Input = String
    public typealias Output = AnyPublisher<[FavoriteTrack],RadioError>

    var radioGateway: RadioGateway?
    var songDelayCalc: SongDelayLogic?
    
    public init(radioGateway: RadioGateway? = nil,
                songDelayCalc: SongDelayLogic? = nil) {
        self.radioGateway = radioGateway
        self.songDelayCalc = songDelayCalc
    }
    
    public func execute(_ input: Input) -> Output {
        guard let songDelayCalc = self.songDelayCalc else { fatalError("missing DI")}
        return self.radioGateway!
            .getFavorites(for: input)
            .map{ tracks -> [FavoriteTrack] in
                var mutableTracks = tracks
                for (index,track) in mutableTracks.enumerated() {
                    let inCD = songDelayCalc.isSongUnderCooldown(track: track)
                    mutableTracks[index].requestable = !inCD
                }
                return mutableTracks
            }
            .eraseToAnyPublisher()
    }
    
}
