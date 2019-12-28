import Foundation
import Combine

public protocol GetSongNameUseCase {
    func execute() -> AnyPublisher<String,Never>
}

public class GetSongNameInteractor: GetSongNameUseCase {
    var avGateway: AVGateway
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() -> AnyPublisher<String, Never>{
        //TODO: This should use the API's info in case a song isn't playing.
        self.avGateway.getSongName()
    }
}
