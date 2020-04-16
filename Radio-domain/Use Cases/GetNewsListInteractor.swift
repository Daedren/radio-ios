import Foundation
import Combine

public class GetNewsListInteractor: Interactor {
    public typealias Input = ()
    public typealias Output = AnyPublisher<[NewsEntry],RadioError>

    var radioGateway: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radioGateway = radioGateway
    }
    
    public func execute(_ input: Input = ()) -> Output {
        self.radioGateway!.getNews()
    }
    
}
