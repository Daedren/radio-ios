import Foundation
import Combine

public protocol GetSongNameUseCase {
    func execute() -> AnyPublisher<TrackTitleArtist,Never>
}

public class GetSongNameInteractor: GetSongNameUseCase {
    var avGateway: AVGateway
    var radioGateway: RadioGateway

    public init(avGateway: AVGateway, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }
    
    public func execute() -> AnyPublisher<TrackTitleArtist, Never>{
        let apiName = self.radioGateway
            .getCurrentTrack()
            .map{ return TrackTitleArtist(title: $0.info.title, artist: $0.info.artist) }
            .catch({err in
                return Empty<TrackTitleArtist,Never>()
            })
            .eraseToAnyPublisher()
        
        return self.avGateway.getSongName()
        .map(mapToArtistAndTitle(model:))
        .compactMap{ $0 }
        .merge(with: apiName)
        .eraseToAnyPublisher()
    }
    
    
    private func mapToArtistAndTitle(model: String) -> TrackTitleArtist? {
        let splitString = model
            .split(separator: "-", maxSplits: 1)
            .map{ $0.trimmingCharacters(in: .whitespacesAndNewlines)}
        
        if splitString.count == 2 {
            return TrackTitleArtist(title: splitString[1], artist: splitString[0])
        }
        return nil
    }
}
