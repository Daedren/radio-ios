import Foundation
import Swinject
import Radio_domain
import SwiftUI

struct SiriSettingsProperties {
    var titleBar: String
}

class SiriSettingsConfigurator: Configurator {
    
    func configureFake() -> SiriSettingsView<SiriSettingsPresenterPreviewer> {
        SiriSettingsView(presenter: SiriSettingsPresenterPreviewer(),
                     properties: SiriSettingsProperties(titleBar: "Siri"))
    }

    func configure() -> SiriSettingsView<SiriSettingsPresenterImp> {
        let properties = SiriSettingsProperties(titleBar: "Siri")
        let view = SiriSettingsView(
            presenter: self.inject().resolve(SiriSettingsPresenterImp.self)!,
            properties: properties
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(SiriSettingsPresenterImp.self) { _ in

                let presenter = SiriSettingsPresenterImp()
                return presenter
            }

        }
    }
}
