import Foundation
import Radio_cross
import Radio_domain
import SwiftUI

struct SettingsProperties {
    var titleBar: String
}

class SettingsConfigurator: Configurator {

    func configure() -> SettingsView<SettingsPresenterImp> {
        self.inject()
        let properties = SettingsProperties(titleBar: "Settings")
        let view = SettingsView<SettingsPresenterImp>(
            properties: properties,
            presenter: InjectSettings.shared.resolve(SettingsPresenterImp.self)!
        )
        return view
    }

    private func inject(){
        
            
            InjectSettings.shared.register(SettingsPresenterImp.self) {

                let presenter = SettingsPresenterImp(
                    sleepUseCase: InjectSettings.shared.resolve(ToggleSleepTimerUseCase.self)!
                )
                return presenter
            }

        }
    }
