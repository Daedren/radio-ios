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
            .map{ track -> QueuedTrack? in
                return track
        }
        .catch({err in
            return Just<QueuedTrack?>(nil)
        })
            .prepend(Just<QueuedTrack?>(nil))
            .eraseToAnyPublisher()
        
        let icyName = self.avGateway.getSongName()
            //            .removeDuplicates()
            .map{ [unowned self] artistAndName -> QueuedTrack? in
                return self.radioGateway
                    .getTrackWith(identifier: artistAndName)
        }
        .prepend(Just<QueuedTrack?>(nil))
            //            .compactMap{ $0 }
            .eraseToAnyPublisher()
        
        let timer = Timer.publish(every: 1.0, on: .current, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
        
        let mergedObs = apiName
            .combineLatest(icyName, timer)
            .flatMap{ [unowned self] (arg) -> AnyPublisher<QueuedTrack,Never> in
                let (api, icy, timer) = arg
                
                var model: QueuedTrack? = nil
                if icy != nil, self.avGateway.isPlaying() {
                    model = icy
                }
                else if api != nil {
                    model = api
                }
                
                if var model = model {
                    model.currentTime = timer
                    if let endDate = model.endTime,
                        timer == endDate {
                        self.radioGateway.updateNow()
                    }
                    return Just(model).eraseToAnyPublisher()
                }
                return Empty<QueuedTrack,Never>().eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
        
        
        return mergedObs
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
