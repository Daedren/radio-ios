import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

class LastPlayedConfigurator: Configurator {
    
    func configureFake() -> LastPlayedView<LastPlayedPresenterPreviewer> {
        LastPlayedView(presenter: LastPlayedPresenterPreviewer())
    }
    
    func configure() -> LastPlayedView<LastPlayedPresenterImp> {
        self.inject()
        let view = LastPlayedView<LastPlayedPresenterImp>(
            presenter: InjectSettings.shared.resolve(LastPlayedPresenterImp.self)!
        )
        return view
    }
    
    private func inject() {
        InjectSettings.shared.register(LastPlayedPresenterImp.self) {
            
            let presenter = LastPlayedPresenterImp(
                lastPlayed: InjectSettings.shared.resolve(GetLastPlayedInteractor.self)!
            )
            return presenter
        }
        
    }
}
