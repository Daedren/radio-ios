import SwiftUI
import Combine

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
        NavigationView {
            if !presenter.state.acceptingRequests {
                Text("We're not currently accepting requests")
                    .font(.largeTitle)
            }
            VStack() {
                SearchWrapper(placeholder: "Insert term to search",
                              textDidChange: self.searchedText)
                List{
                    Section(footer: Text("You can request once every 30 minutes.\nSong cooldown is variable.")){
                        VStack {
                            requestTimeText()
                                .font(.headline)
                            Spacer()
                            if presenter.state.tracks.count > 1 {
                                SongRequestButton(
                                    viewModel: presenter.state.randomTrack,
                                    isLoading: self.presenter.state.loadingRandom,
                                    action: { self.actions.send(.chooseRandom) }
                                )
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    Section(header: Text("Results")) {
                        ForEach(Array(self.presenter.state.tracks.enumerated()), id: \.offset) { index, item in
                            self.buttonFor(index: index, item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .styledList()
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle(properties.titleBar)
            }
        }
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
                isLoading: self.presenter.state.loadingTracks[index] ?? false,
                action: { self.actions.send(.choose(index)) })
        }
    }
    
    func requestTimeText() -> Text {
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
                          .environment(\.colorScheme, .dark)
        }
    }
}

