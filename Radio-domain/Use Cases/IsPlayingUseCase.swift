import Foundation
import Combine

public protocol IsPlayingUseCase {
    func execute() -> AnyPublisher<Bool,Never>
}

public class IsPlayingInteractor: IsPlayingUseCase {
    var avGateway: MusicGateway
    
    public init(avGateway: MusicGateway) {
        self.avGateway = avGateway
    }

    public func execute() -> AnyPublisher<Bool,Never> {
        avGateway.publishedIsPlaying()
    }

}
