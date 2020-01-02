import Foundation
import UIKit
import SwiftUI

struct SearchWrapper: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    let controller = UISearchController()
    @Binding var inputtedText: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $inputtedText)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchWrapper>) -> UISearchBar {
        self.controller.searchBar.delegate = context.coordinator
        return self.controller.searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchWrapper>) {

    }

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text : String
        init(text : Binding<String>)
        {
           _text = text
        }
        func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String)
        {
           text = searchText
        }
    }

}
