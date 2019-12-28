import Foundation
import Combine

public class GetDJInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<RadioDJ,RadioError>

    var radio: RadioGateway?
    
    public init(radio: RadioGateway? = nil) {
        self.radio = radio
    }
    
    public func execute(_: () = ()) -> AnyPublisher<RadioDJ, RadioError> {
        self.radio!.getCurrentDJ()
    }
    
}
