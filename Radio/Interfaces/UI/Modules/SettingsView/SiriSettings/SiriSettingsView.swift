import SwiftUI
import Radio_interfaces
import Combine


struct NavigationButton<CV: View, NV: View>: View {
    @State private var isPresented = false
    
    var contentView: CV
    var navigationView: (Binding<Bool>) -> NV
    
    var body: some View {
        Button(action: {
            self.isPresented = true
        }) {
            contentView
                .background(
                    navigationView($isPresented)
                )
        }
    }
}

enum SiriSettingsViewAction: Equatable {
    case tappedOption(Int)
}

struct SiriSettingsView<P: SiriSettingsPresenter>: View {
    @ObservedObject var presenter: P
    @State var presentSheet: Bool = false
    
    
    var actions = PassthroughSubject<SiriSettingsViewAction, Never>()
    let properties: SiriSettingsProperties
    let wireframe: SiriSettingsWireframe = SiriSettingsWireframe()
    
    var body: some View {
        VStack {
            List {
                Section(footer:
                        Text("Tap to add/remove a Siri Shortcut for the chosen action.")
                    .font(.footnote)
                            ) {
                    ForEach(Array(self.presenter.state.options.enumerated()), id: \.offset) {
                    index, item in
                        Button(action: {
                            self.actions.send(.tappedOption(index))
                        }) {
                            ListOptionView(viewModel: item)
                        }
                    }
                }

                
            }
        }
        .navigationBarTitle(properties.titleBar)
        .sheet(item: $presenter.leave, content: self.wireframe.destination)
    }
    
    init(presenter: P, properties: SiriSettingsProperties) {
        self.presenter = presenter
        self.properties = properties
        
        self.presenter.start(actions:
            actions.eraseToAnyPublisher())
    }
}

struct SiriSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SiriSettingsConfigurator().configureFake()
    }
}
