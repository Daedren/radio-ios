import Foundation
import Radio_Domain
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
        self.avGateway.getSongName()
    }
}
