import Foundation
import Swinject
import Radio_domain
import SwiftUI

class LastPlayedConfigurator: Configurator {
    
    func configureFake() -> LastPlayedView<LastPlayedPresenterPreviewer> {
        LastPlayedView(presenter: LastPlayedPresenterPreviewer())
    }

    func configure() -> LastPlayedView<LastPlayedPresenterImp> {
        let view = LastPlayedView<LastPlayedPresenterImp>(
            presenter: self.inject().resolve(LastPlayedPresenterImp.self)!
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(LastPlayedPresenterImp.self) { _ in

                let presenter = LastPlayedPresenterImp(
                    lastPlayed: self.assembler.resolver.resolve(GetLastPlayedInteractor.self)!
                )
                return presenter
            }

        }
    }
}
