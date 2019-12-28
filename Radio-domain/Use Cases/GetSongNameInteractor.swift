import Foundation
import Combine

public protocol GetSongNameUseCase {
    func execute() -> AnyPublisher<String,Never>
}

public class GetSongNameInteractor: GetSongNameUseCase {
    var avGateway: AVGateway
    var radioGateway: RadioGateway
    
    public init(avGateway: AVGateway, radioGateway: RadioGateway) {
        self.avGateway = avGateway
        self.radioGateway = radioGateway
    }
    
    public func execute() -> AnyPublisher<String, Never>{
        let apiName = self.radioGateway
            .getCurrentTrack()
            .map{ return "\($0.artist) - \($0.title)" }
            .catch({err in
                return Empty<String,Never>()
            })
            .eraseToAnyPublisher()
        
        return self.avGateway.getSongName()
        .merge(with: apiName)
        .eraseToAnyPublisher()
    }
}
