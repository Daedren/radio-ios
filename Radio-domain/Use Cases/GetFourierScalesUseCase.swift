import Foundation
import Combine

public protocol GetFourierScalesUseCase {
    func execute() -> AnyPublisher<[Float],Never>
}

public class GetFourierScalesInteractor: GetFourierScalesUseCase {
    let avGateway: AVGateway

    public init(avGateway: AVGateway) {
        self.avGateway = avGateway
    }
    
    public func execute() -> AnyPublisher<[Float],Never> {
        return avGateway.getScales()
    }

}
