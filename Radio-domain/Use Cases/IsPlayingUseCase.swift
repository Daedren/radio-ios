import Foundation
import Combine

public protocol IsPlayingUseCase {
    func execute() -> AnyPublisher<Bool,Never>
}

public class IsPlayingInteractor: IsPlayingUseCase {
    var avGateway: AVGateway
    
    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }

    public func execute() -> AnyPublisher<Bool,Never> {
        avGateway.publishedIsPlaying()
    }

}
