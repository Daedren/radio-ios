import Foundation
import Swinject
import Radio_Domain
import SwiftUI

class MusicSearchConfigurator: Configurator {
    
//    func configureFake() -> SearchView<SearchPresenterPreviewer> {
//        SearchView(presenter: SearchPresenterPreviewer())
//    }

    func configure() -> SearchView<MusicSearchPresenterImp> {
        let view = SearchView<MusicSearchPresenterImp>(
            presenter: self.inject().resolve(MusicSearchPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(MusicSearchPresenterImp.self) { _ in

                let presenter = MusicSearchPresenterImp(
                    searchInteractor: self.assembler.resolver.resolve(SearchForTermInteractor.self)!,
                    requestInteractor: self.assembler.resolver.resolve(RequestSongInteractor.self)!,
                    statusInteractor: self.assembler.resolver.resolve(GetCurrentStatusInteractor.self)!
                )
                return presenter
            }

        }
    }
}
