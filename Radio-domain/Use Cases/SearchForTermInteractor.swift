import Foundation
import Combine

public protocol SearchForTermUseCase {
    func execute(_ input: String) -> AnyPublisher<[SearchedTrack],RadioError>
}

public class SearchForTermInteractor: SearchForTermUseCase {
    var radioGateway: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radioGateway = radioGateway
    }
    
    public func execute(_ input: String) -> AnyPublisher<[SearchedTrack],RadioError> {
        self.radioGateway!.searchFor(term: input)
    }
    
}
