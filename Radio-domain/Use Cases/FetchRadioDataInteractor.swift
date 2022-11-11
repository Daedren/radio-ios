import Foundation
import Combine

public protocol FetchRadioDataUseCase {
    func execute(_: ()) -> AnyPublisher<Void, RadioError>
}

public class FetchRadioDataInteractor: Interactor, FetchRadioDataUseCase {
    public typealias Input = Void
    public typealias Output = AnyPublisher<Void, RadioError>

    var radio: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radio = radioGateway
    }
    
    public func execute(_: () = ()) -> AnyPublisher<Void, RadioError> {
        self.radio!.updateNow()
    }
    
}
