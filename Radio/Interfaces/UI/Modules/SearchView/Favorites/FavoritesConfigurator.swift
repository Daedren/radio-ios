import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class FavoritesConfigurator {
    
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
                    requestInteractor: InjectSettings.shared.resolve(RequestSongUseCase.self)!,
                    statusInteractor: InjectSettings.shared.resolve(GetCurrentStatusUseCase.self)!,
                    cooldownInteractor: InjectSettings.shared.resolve(CanRequestSongUseCase.self)!,
                    lastUsername: InjectSettings.shared.resolve(GetLastFavoriteUserUseCase.self)!
                )
                return presenter
            }

        }
    }
