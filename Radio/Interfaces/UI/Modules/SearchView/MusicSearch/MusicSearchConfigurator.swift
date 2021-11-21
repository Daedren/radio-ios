import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class MusicSearchConfigurator: Configurator {
    
//    func configureFake() -> SearchView<SearchPresenterPreviewer> {
//        SearchView(presenter: SearchPresenterPreviewer())
//    }

    func configure() -> SearchView<MusicSearchPresenterImp> {
        let properties = SearchListProperties(titleBar: "Search")
        
        self.inject()
        let view = SearchView<MusicSearchPresenterImp>(
            presenter: InjectSettings.shared.resolve(MusicSearchPresenterImp.self)!,
            properties: properties
        )
        return view
    }

    private func inject(){
        
            
            InjectSettings.shared.register(MusicSearchPresenterImp.self) {

                let presenter = MusicSearchPresenterImp(
                    searchInteractor: InjectSettings.shared.resolve(SearchForTermInteractor.self)!,
                    requestInteractor: InjectSettings.shared.resolve(RequestSongInteractor.self)!,
                    statusInteractor: InjectSettings.shared.resolve(GetCurrentStatusInteractor.self)!,
                    cooldownInteractor: InjectSettings.shared.resolve(CanRequestSongInteractor.self)!
                )
                return presenter
            }

        }
}
