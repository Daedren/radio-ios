import SwiftUI
import Combine

struct SearchListProperties {
    var titleBar: String
}

enum SearchListAction: Equatable {
    case chooseRandom
    case choose(Int)
    case search(String)
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
            }
            VStack() {
                SearchWrapper(placeholder: "Insert term to search",
                              textDidChange: self.searchedText)
                List{
                    if presenter.state.randomTrack != nil {
                        Section {
                            SongRequestButton(
                                viewModel: presenter.state.randomTrack!,
                                isLoading: self.presenter.state.loadingRandom,
                                action: { self.actions.send(.chooseRandom) }
                            )
                                .frame(maxWidth: .infinity)
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    Section {
                        ForEach(Array(self.presenter.state.tracks.enumerated()), id: \.offset) { index, item in
                            self.buttonFor(index: index, item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                Spacer()
                    .navigationBarTitle(properties.titleBar)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
}

//struct SearchView_Previews: PreviewProvider {
//    let pres = SearchPresenterPreviewer()
//    static var previews: some View {
//        Group {
//            SearchView(presenter: pres)
//              .environment(\.colorScheme, .light)
//
//           SearchView()
//              .environment(\.colorScheme, .dark)
//        }
//    }
//}
