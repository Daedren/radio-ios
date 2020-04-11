import Foundation
import Swinject
import Radio_Domain
import SwiftUI

class FavoritesConfigurator: Configurator {
    
//    func configureFake() -> FavoritesView<FavoritesPresenterPreviewer> {
//        FavoritesView(presenter: FavoritesPresenterPreviewer())
//    }

    func configure() -> FavoritesView {
        let view = FavoritesView(
            presenter: self.inject().resolve(FavoritesPresenterImp.self)!
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
