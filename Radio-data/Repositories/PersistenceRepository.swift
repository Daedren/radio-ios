import Foundation
import Radio_domain
import Combine

enum UserDefaultsKeys: String {
    case LastFavoriteUsername
}

class PersistenceRepository: PersistenceGateway {
    let standardDefaults = UserDefaults.standard
    let groupDefaults = UserDefaults(suiteName: "group.cc.raik.radio")


    func setFavoriteDefault(name: String) async {
        groupDefaults?.set(name, forKey: UserDefaultsKeys.LastFavoriteUsername.rawValue)
    }
    
    func getFavoriteDefault() -> Future<String, Never> {
        return Future.init { [weak self] event in
            event(.success(
                self?.groupDefaults?.string(forKey: UserDefaultsKeys.LastFavoriteUsername.rawValue) ?? "")
            )
        }
    }
    
    
}
