import Foundation
import Combine

public protocol GetCurrentTrackUseCase {
    func execute() -> AnyPublisher<QueuedTrack,Never>
}

public class GetCurrentTrackInteractor: GetCurrentTrackUseCase {
    var avGateway: AVGateway
    var radioGateway: RadioGateway
    
    public init(avGateway: AVGateway, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }
    
    public func execute() -> AnyPublisher<QueuedTrack, Never>{
        let apiName = self.radioGateway
            .getCurrentTrack()
            .map{ return BaseTrack(title: $0.title, artist: $0.artist) }
            .catch({err in
                return Empty<BaseTrack,Never>()
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
                return Empty<QueuedTrack,Never>()
            })
            .combineLatest(mergedObs, mergeTrackAndName(track:name:))
            .eraseToAnyPublisher()

        return track
    }
    
    private func mergeTrackAndName(track: QueuedTrack, name: Track) -> QueuedTrack {
        var newTrack = track
        newTrack.title = name.title
        newTrack.artist = name.artist
        return newTrack
    }
    
    
    private func mapToArtistAndTitle(model: String) -> BaseTrack? {
        let separator = " - "
        guard let range = model
            .range(of: separator)
            else { return nil }
        
        let finalString = [model.prefix(upTo: range.lowerBound), model.suffix(from: range.upperBound)]
        
        if finalString.count == 2 {
            return BaseTrack(title: String(finalString[1]), artist: String(finalString[0]))
        }
        return nil
    }
}
