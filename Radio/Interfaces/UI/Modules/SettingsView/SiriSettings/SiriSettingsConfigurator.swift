import Foundation
import Radio_cross
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
        self.inject()
        let properties = SiriSettingsProperties(titleBar: "Siri")
        let view = SiriSettingsView(
            presenter: InjectSettings.shared.resolve(SiriSettingsPresenterImp.self)!,
            properties: properties
        )
        return view
    }
    
    private func inject() {
        InjectSettings.shared.register(SiriSettingsPresenterImp.self) {
            let presenter = SiriSettingsPresenterImp()
            return presenter
        }
    }
}
