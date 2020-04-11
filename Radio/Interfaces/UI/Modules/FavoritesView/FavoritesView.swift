import SwiftUI

struct FavoritesView: View {
    @ObservedObject var presenter: FavoritesPresenterImp

    var body: some View {
        NavigationView {
            if !presenter.acceptingRequests {
                Text("We're not currently accepting requests")
            }
            VStack() {
                SearchWrapper(inputtedText: $presenter.searchedText, placeholder: "Username")
                List(presenter.returnedValues.enumerated().map({$0}), id: \.element.id){ (index, item) in
                    HStack {
                        Text("\(item.artist) - \(item.title)")
                        Spacer()
                        SongRequestButton(index: index, track: item, action: self.presenter.request(_:))

                    }
                }
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                Spacer()
                    .navigationBarTitle("Favorites")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//struct FavoritesView_Previews: PreviewProvider {
//    static var previews: some View {
//        FavoritesView()
//    }
//}
