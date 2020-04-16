import Foundation
import UIKit
import SwiftUI

struct SearchWrapper: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    @Binding var inputtedText: String
    let searchBar = UISearchBar()
    let placeholder: String?
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $inputtedText)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchWrapper>) -> UISearchBar {
        self.searchBar.delegate = context.coordinator
        self.searchBar.placeholder = self.placeholder
        return self.searchBar
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
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            text = ""
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

}
