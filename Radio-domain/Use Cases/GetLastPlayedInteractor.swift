import Foundation
import Combine

public class GetLastPlayedInteractor: Interactor {
    public typealias Input = Void
    public typealias Output = AnyPublisher<[Track],RadioError>

    var radio: RadioGateway?
    
    public init(radio: RadioGateway? = nil) {
        self.radio = radio
    }
    
    public func execute(_: () = ()) -> AnyPublisher<[Track], RadioError> {
        self.radio!.getLastPlayed()
    }
    
}
