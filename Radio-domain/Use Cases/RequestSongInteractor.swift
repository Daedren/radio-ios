import Foundation
import Combine


public class RequestSongInteractor: Interactor {
    public typealias Input = Int
    public typealias Output = AnyPublisher<(),RadioError>

    var radioGateway: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radioGateway = radioGateway
    }
    
    public func execute(_ input: Input) -> Output {
        self.radioGateway!.request(songId: input)
    }
    
}
