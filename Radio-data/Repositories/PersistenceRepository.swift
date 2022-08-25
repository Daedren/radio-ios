import Foundation
import Radio_domain
import Combine

enum UserDefaultsKeys: String {
    case LastFavoriteUsername
}

class PersistenceRepository: PersistenceGateway {
    func setFavoriteDefault(name: String) async {
        UserDefaults.standard.set(name, forKey: UserDefaultsKeys.LastFavoriteUsername.rawValue)
    }
    
    func getFavoriteDefault() -> Future<String, Never> {
        return Future.init { event in
            
            event(.success(
                UserDefaults.standard.string(forKey: UserDefaultsKeys.LastFavoriteUsername.rawValue) ?? "")
            )
        }
    }
    
    
}
