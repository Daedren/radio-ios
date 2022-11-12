import SwiftUI
import Combine
import Radio_interfaces

struct SearchListProperties {
    var titleBar: String
}

enum SearchListAction: Equatable {
    case chooseRandom
    case choose(Int)
    case search(String)
    case viewDidAppear
    
}


struct SearchView<P: SearchPresenter>: View {
    @ObservedObject var presenter: P
    var searchedText = PassthroughSubject<String, Never>()
    
    var properties: SearchListProperties
    var actions = PassthroughSubject<SearchListAction, Never>()
    
    init(presenter: P, properties: SearchListProperties) {
        self.presenter = presenter
        self.properties = properties
        
        let text = searchedText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter{ $0 != ""}
            .map{ SearchListAction.search($0) }
        
        self.presenter.start(actions:
                                actions
                                .merge(with: text)
                                .eraseToAnyPublisher())
    }
    
    var body: some View {
        Group {
            if !presenter.state.acceptingRequests {
                Text("We're not currently accepting requests")
                    .font(.largeTitle)
            }
            VStack() {
                SearchWrapper(placeholder: "Insert term to search",
                              textDidChange: self.searchedText,
                              text: $presenter.state.searchTerm
                )
                List{
                    Section(footer: Text("You can request once every 30 minutes.\nSong cooldown is variable.")
                        .font(.footnote)
                    ){
                        VStack {
                            requestTimeText()
                                .animation(.easeInOut(duration: 0.3), value: presenter.state)
                                .font(.headline)
                            Spacer()
                            if presenter.state.tracks.count > 1 {
                                SongRequestButton(
                                    viewModel: presenter.state.randomTrack,
                                    action: { _ in self.actions.send(.chooseRandom) }
                                )
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Section(header: Text("Results")
                        .font(.footnote)
                    ) {
                        ForEach(Array(self.presenter.state.tracks.enumerated()), id: \.offset) { index, item in
                            self.buttonFor(index: index, item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }.animation(.default, value: presenter.state.tracks)
                .styledList()
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                .environment(\.horizontalSizeClass, .regular)
            }
        }
        .navigationBarTitle(properties.titleBar)
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.actions.send(.viewDidAppear)
        }
    }
    
    func buttonFor(index: Int, item: SearchedTrackViewModel) -> some View {
        HStack {
            Text("\(item.fullText)")
                .font(.body)
            Spacer()
            SongRequestButton(
                viewModel: item,
                action: { _ in self.actions.send(.choose(index)) })
        }
    }
    
    func requestTimeText() -> Text {
        if presenter.state.loadingGeneral {
            return Text("")
        }
        if presenter.state.canRequest {
            return Text("You can now request.")
        } else if let date = presenter.state.canRequestAt{
            return Text("On cooldown until \(date)")
        } else {
            return Text("On cooldown")
        }

    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView<SearchPresenterPreviewer>(
                presenter: SearchPresenterPreviewer(),
                properties:
                    SearchListProperties(titleBar: "Search"))
        }
    }
}

