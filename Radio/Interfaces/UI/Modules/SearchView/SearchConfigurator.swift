import Foundation
import Swinject
import Radio_Domain
import SwiftUI

class SearchConfigurator: Configurator {
    
//    func configureFake() -> SearchView<SearchPresenterPreviewer> {
//        SearchView(presenter: SearchPresenterPreviewer())
//    }

    func configure() -> SearchView {
        let view = SearchView(
            presenter: self.inject().resolve(SearchPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(SearchPresenterImp.self) { _ in

                let presenter = SearchPresenterImp(
                    searchInteractor: self.assembler.resolver.resolve(SearchForTermInteractor.self)!
                )
                return presenter
            }

        }
    }
}
