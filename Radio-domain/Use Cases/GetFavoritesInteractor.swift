import Foundation
import Combine

public class GetFavoritesInteractor: Interactor {
    public typealias Input = String
    public typealias Output = AnyPublisher<[FavoriteTrack],RadioError>

    var radioGateway: RadioGateway?
    var songDelayCalc: SongDelayLogic?
    var persistence: PersistenceGateway?
    
    public init(radioGateway: RadioGateway? = nil,
                persistence: PersistenceGateway? = nil,
                songDelayCalc: SongDelayLogic? = nil) {
        self.radioGateway = radioGateway
        self.songDelayCalc = songDelayCalc
        self.persistence = persistence
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
            .handleEvents(receiveOutput: { [weak self] favorites in
                if !favorites.isEmpty {
                    Task { [weak self] in
                      await self?.persistence?.setFavoriteDefault(name: input)
                    }
                }
            })
            .eraseToAnyPublisher()
    }
    
}
