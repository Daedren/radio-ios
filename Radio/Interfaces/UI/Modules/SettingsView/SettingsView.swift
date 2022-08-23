import SwiftUI
import Combine

enum SettingsViewAction: Equatable {
    case tappedOption(Int)
    case setSleepTimer(Date)
    case toggleSleepTimer(Bool)
}

struct SettingsView<P: SettingsPresenter>: View {
    @ObservedObject var presenter: P
    let properties: SettingsProperties
    
    var actions = PassthroughSubject<SettingsViewAction, Never>()
    
    var body: some View {
            List {
                NavigationLink(destination: self.goToSiri()) {
                    Text("Siri")
                        .font(.body)
                }
                Toggle("Sleep timer", isOn: Binding<Bool>(
                    get: {
                        self.presenter.state.sleepTimerEnabled
                    },
                    set: { switchValue in
                        self.actions.send(.toggleSleepTimer(switchValue))
                    }
                )).animation(.linear(duration: 0.5))
                        .font(.body)
                if presenter.state.sleepTimerEnabled {
                    DatePicker(selection: Binding<Date>(get: {
                        self.presenter.state.sleepTimer
                    }, set: { date in
                        self.actions.send(.setSleepTimer(date))
                    }),
                               in: Date()...Date(timeIntervalSinceNow: TimeInterval(18000)),
                               displayedComponents: [.hourAndMinute]) {
                            Text(".. but WHEN")
                        .font(.body)
                        }
            }
            }
            .navigationBarTitle(properties.titleBar)
    }
    
    init(properties: SettingsProperties,
         presenter: P) {
        self.properties = properties
        self.presenter = presenter
        
        self.presenter.start(actions: self.actions.eraseToAnyPublisher())
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
