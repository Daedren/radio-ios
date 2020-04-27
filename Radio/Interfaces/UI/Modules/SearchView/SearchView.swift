import SwiftUI

protocol SearchPresenter: ObservableObject {
    var searchedText: String { get set }
    var returnedValues: [SearchedTrackViewModel] { get set }
    var randomTrack: RandomTrackViewModel { get set }
    var acceptingRequests: Bool { get set }
    var titleBarText: String { get set }
    func request(track: SearchedTrackViewModel)
    func requestRandom(track: RandomTrackViewModel)
}

struct SearchView<P: SearchPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
        NavigationView {
            if !presenter.acceptingRequests {
                Text("We're not currently accepting requests")
            }
            VStack() {
                SearchWrapper(inputtedText: $presenter.searchedText, placeholder: "Insert term to search")
                List{
                    Section {
                        SongRequestButton<RandomTrackViewModel>(viewModel: presenter.randomTrack, action: self.presenter.requestRandom)
                        .frame(maxWidth: .infinity)
                        .buttonStyle(PlainButtonStyle())
                    }
                    Section {
                        ForEach(presenter.returnedValues) { item in
                            HStack {
                                Text("\(item.artist) - \(item.title)")
                                    .font(.body)
                                Spacer()
                                SongRequestButton<SearchedTrackViewModel>(viewModel: item, action: self.presenter.request(track:))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                Spacer()
                    .navigationBarTitle(presenter.titleBarText)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
