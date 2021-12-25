import Foundation
import Combine

public protocol GetCurrentStatusUseCase {
    func execute() -> AnyPublisher<RadioStatus, RadioError>
}

public class GetCurrentStatusInteractor: GetCurrentStatusUseCase {
    var radio: RadioGateway?
    
    public init(radio: RadioGateway? = nil) {
        self.radio = radio
    }
    
    public func execute() -> AnyPublisher<RadioStatus, RadioError> {
        self.radio!.getCurrentStatus()
    }
    
}
