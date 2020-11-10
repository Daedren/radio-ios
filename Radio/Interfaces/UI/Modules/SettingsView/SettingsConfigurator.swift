import Foundation
import Swinject
import Radio_domain
import SwiftUI

struct SettingsProperties {
    var titleBar: String
}

class SettingsConfigurator: Configurator {

    func configure() -> SettingsView {
        let properties = SettingsProperties(titleBar: "Settings")
        let view = SettingsView(
            properties: properties
        )
        return view
    }

    private func inject() -> Container {
        return Container { container in
            
            container.register(SettingsPresenterImp.self) { _ in

                let presenter = SettingsPresenterImp()
                return presenter
            }

        }
    }
}
