import Foundation
import Combine

public class GetCurrentStatusInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<RadioStatus,RadioError>

    var radio: RadioGateway?
    
    public init(radio: RadioGateway? = nil) {
        self.radio = radio
    }
    
    public func execute(_: () = ()) -> AnyPublisher<RadioStatus, RadioError> {
        self.radio!.getCurrentStatus()
    }
    
}
