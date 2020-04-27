import SwiftUI

protocol SearchPresenter: ObservableObject {
    var searchedText: String { get set }
    var returnedValues: [SearchedTrackViewModel] { get set }
    var acceptingRequests: Bool { get set }
    func request(_ index: Int)
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
                List(presenter.returnedValues.enumerated().map({$0}), id: \.element.id){ (index, item) in
                    HStack {
                        Text("\(item.artist) - \(item.title)")
                        .font(.body)
                        Spacer()
                        SongRequestButton(index: index, track: item, action: self.presenter.request(_:))

                    }
                }
                .gesture(DragGesture().onChanged { _ in
                    UIApplication.shared.windows.forEach { $0.endEditing(false) }
                })
                Spacer()
                    .navigationBarTitle("Search")
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


//struct SearchView: View {
//    let array = ["Peter", "Paul", "Mary", "Anna-Lena", "George", "John", "Greg", "Thomas", "Robert", "Bernie", "Mike", "Benno", "Hugo", "Miles", "Michael", "Mikel", "Tim", "Tom", "Lottie", "Lorrie", "Barbara"]
//    @State private var searchText = ""
//    @State private var showCancelButton: Bool = false
//
//    var body: some View {
//
//        NavigationView {
//            VStack {
//                // Search view
//                HStack {
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//
//                        TextField("search", text: $searchText, onEditingChanged: { isEditing in
//                            self.showCancelButton = true
//                        }, onCommit: {
//                            print("onCommit")
//                        }).foregroundColor(.primary)
//
//                        Button(action: {
//                            self.searchText = ""
//                        }) {
//                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
//                        }
//                    }
//                    .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
//                    .foregroundColor(.secondary)
//                    .background(Color(.secondarySystemBackground))
//                    .cornerRadius(10.0)
//
//                    if showCancelButton  {
//                        Button("Cancel") {
//                                UIApplication.shared.endEditing(true) // this must be placed before the other commands here
//                                self.searchText = ""
//                                self.showCancelButton = false
//                        }
//                        .foregroundColor(Color(.systemBlue))
//                    }
//                }
//                .padding(.horizontal)
//                .navigationBarHidden(showCancelButton) // .animation(.default) // animation does not work properly
//
//                List {
//                    // Filtered list of names
//                    ForEach(array.filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self) {
//                        searchText in Text(searchText)
//                    }
//                }
//                .navigationBarTitle(Text("Search"))
//                .resignKeyboardOnDragGesture()
//            }
//        }
//    }
//}
//
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//           SearchView()
//              .environment(\.colorScheme, .light)
//
//           SearchView()
//              .environment(\.colorScheme, .dark)
//        }
//    }
//}
//
//extension UIApplication {
//    func endEditing(_ force: Bool) {
//        self.windows
//            .filter{$0.isKeyWindow}
//            .first?
//            .endEditing(force)
//    }
//}
//
//struct ResignKeyboardOnDragGesture: ViewModifier {
//    var gesture = DragGesture().onChanged{_ in
//        UIApplication.shared.endEditing(true)
//    }
//    func body(content: Content) -> some View {
//        content.gesture(gesture)
//    }
//}
//
//extension View {
//    func resignKeyboardOnDragGesture() -> some View {
//        return modifier(ResignKeyboardOnDragGesture())
//    }
//}