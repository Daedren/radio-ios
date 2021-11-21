import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class FavoritesConfigurator: Configurator {
    
//    func configureFake() -> FavoritesView<FavoritesPresenterPreviewer> {
//        FavoritesView(presenter: FavoritesPresenterPreviewer())
//    }

    func configure() -> SearchView<FavoritesPresenterImp> {
        let properties = SearchListProperties(titleBar: "Favorites")
        
        self.inject()
        let view = SearchView<FavoritesPresenterImp>(
            presenter: InjectSettings.shared.resolve(FavoritesPresenterImp.self)!,
            properties: properties
        )
        return view
    }

    private func inject(){
        
            
            InjectSettings.shared.register(FavoritesPresenterImp.self) {

                let presenter = FavoritesPresenterImp(
                    searchInteractor: InjectSettings.shared.resolve(GetFavoritesInteractor.self)!,
                    requestInteractor: InjectSettings.shared.resolve(RequestSongInteractor.self)!,
                    statusInteractor: InjectSettings.shared.resolve(GetCurrentStatusInteractor.self)!,
                    cooldownInteractor: InjectSettings.shared.resolve(CanRequestSongInteractor.self)!
                )
                return presenter
            }

        }
    }
