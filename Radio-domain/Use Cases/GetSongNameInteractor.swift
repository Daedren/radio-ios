import Foundation
import Radio_Domain
import Combine

public class GetSongNameInteractor: Interactor {
    var avGateway: AVGateway
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() -> AnyPublisher<String, Never>{
        self.avGateway.getSongName()
    }
}
