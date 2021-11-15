import Foundation
import Combine

public protocol GetFourierScalesUseCase {
    func execute() -> AnyPublisher<[Float],Never>
}

public class GetFourierScalesInteractor: GetFourierScalesUseCase {
    let avGateway: MusicGateway

    public init(avGateway: MusicGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() -> AnyPublisher<[Float],Never> {
        return avGateway.getScales()
    }

}
