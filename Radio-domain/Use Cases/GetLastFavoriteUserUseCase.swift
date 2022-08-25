import Foundation
import Combine

public protocol GetLastFavoriteUserUseCase {
    func execute() -> Future<String, Never>
}

public class GetLastFavoriteUserInteractor: GetLastFavoriteUserUseCase {
    let persistence: PersistenceGateway

    public init(persistence: PersistenceGateway) {
        self.persistence = persistence
    }
    
    public func execute() -> Future<String, Never> {
        return self.persistence.getFavoriteDefault()
    }
}
