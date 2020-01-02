import Foundation
import Combine

public class SearchForTermInteractor: Interactor {
    public typealias Input = String
    public typealias Output = AnyPublisher<[SearchedTrack],RadioError>

    var radioGateway: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radioGateway = radioGateway
    }
    
    public func execute(_ input: Input) -> Output {
        self.radioGateway!.searchFor(term: input)
    }
    
}
