import Foundation
import Combine

public protocol PersistenceGateway {
    func setFavoriteDefault(name: String) async
    func getFavoriteDefault() -> Future<String, Never>
}
