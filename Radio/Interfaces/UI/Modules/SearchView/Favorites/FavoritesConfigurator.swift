import Foundation
import Swinject
import Radio_Domain
import SwiftUI

class FavoritesConfigurator: Configurator {
    
//    func configureFake() -> FavoritesView<FavoritesPresenterPreviewer> {
//        FavoritesView(presenter: FavoritesPresenterPreviewer())
//    }

    func configure() -> SearchView<FavoritesPresenterImp> {
        let properties = SearchListProperties(titleBar: "Favorites")
        
        let view = SearchView<FavoritesPresenterImp>(
            presenter: self.inject().resolve(FavoritesPresenterImp.self)!,
            properties: properties
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(FavoritesPresenterImp.self) { _ in

                let presenter = FavoritesPresenterImp(
                    searchInteractor: self.assembler.resolver.resolve(GetFavoritesInteractor.self)!,
                    requestInteractor: self.assembler.resolver.resolve(RequestSongInteractor.self)!,
                    statusInteractor: self.assembler.resolver.resolve(GetCurrentStatusInteractor.self)!
                )
                return presenter
            }

        }
    }
}
