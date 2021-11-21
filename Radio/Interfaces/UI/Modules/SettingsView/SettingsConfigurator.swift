import Foundation
import Radio_cross
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

    private func inject(){
        
            
            InjectSettings.shared.register(SettingsPresenterImp.self) {

                let presenter = SettingsPresenterImp()
                return presenter
            }

        }
    }
