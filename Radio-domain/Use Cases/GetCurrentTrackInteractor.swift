import Foundation
import Combine

public protocol GetCurrentTrackUseCase {
    func execute() -> AnyPublisher<Track,Never>
}

public class GetCurrentTrackInteractor: GetCurrentTrackUseCase {
    var avGateway: AVGateway
    var radioGateway: RadioGateway
    
    public init(avGateway: AVGateway, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }
    
    public func execute() -> AnyPublisher<Track, Never>{
        let apiName = self.radioGateway
            .getCurrentTrack()
            .map{ return TrackTitleArtist(title: $0.info.title, artist: $0.info.artist) }
            .catch({err in
                return Empty<TrackTitleArtist,Never>()
            })
            .eraseToAnyPublisher()
        
        let icyName = self.avGateway.getSongName()
            .map(mapToArtistAndTitle(model:))
            .compactMap{ $0 }
            .eraseToAnyPublisher()
        
        let mergedObs = apiName.merge(with: icyName)
            .eraseToAnyPublisher()
        
        let track = self.radioGateway.getCurrentTrack()
            .catch({err in
                return Empty<Track,Never>()
            })
            .combineLatest(mergedObs, mergeTrackAndName(track:name:))
            .eraseToAnyPublisher()

        return track
    }
    
    private func mergeTrackAndName(track: Track, name: TrackTitleArtist) -> Track {
        var newTrack = track
        newTrack.info = name
        return newTrack
    }
    
    
    private func mapToArtistAndTitle(model: String) -> TrackTitleArtist? {
        let separator = " - "
        guard let range = model
            .range(of: separator)
            else { return nil }
        
        let finalString = [model.prefix(upTo: range.lowerBound), model.suffix(from: range.upperBound)]
        
        if finalString.count == 2 {
            return TrackTitleArtist(title: String(finalString[1]), artist: String(finalString[0]))
        }
        return nil
    }
}
