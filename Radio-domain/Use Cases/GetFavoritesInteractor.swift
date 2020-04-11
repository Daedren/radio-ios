import Foundation
import Combine

public class GetFavoritesInteractor: Interactor {
    public typealias Input = String
    public typealias Output = AnyPublisher<[FavoriteTrack],RadioError>

    var radioGateway: RadioGateway?
    
    public init(radioGateway: RadioGateway? = nil) {
        self.radioGateway = radioGateway
    }
    
    public func execute(_ input: Input) -> Output {
        self.radioGateway!.getFavorites(for: input)
    }
    
}
