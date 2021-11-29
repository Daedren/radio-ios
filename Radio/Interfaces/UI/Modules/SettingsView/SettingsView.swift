import SwiftUI
import Combine

enum SettingsViewAction: Equatable {
    case tappedOption(Int)
}

struct SettingsView: View {
    var actions = PassthroughSubject<SettingsViewAction, Never>()
    let properties: SettingsProperties
    
    var body: some View {
            List {
                NavigationLink(destination: self.goToSiri()) {
                    Text("Siri")
                        .font(.body)
                }
            }
            .navigationBarTitle(properties.titleBar)
    }
    
    init(properties: SettingsProperties) {
        self.properties = properties
    }
    
    func goToSiri() -> some View {
        return SiriSettingsConfigurator().configure()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsConfigurator().configure()
    }
}
