import Foundation
import UIKit
import SwiftUI
import Combine

struct SearchWrapper: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    let searchBar = UISearchBar()
    let placeholder: String?
    let textDidChange: PassthroughSubject<String, Never>
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(changeClosure: textDidChange)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchWrapper>) -> UISearchBar {
        self.searchBar.delegate = context.coordinator
        self.searchBar.placeholder = self.placeholder
        return self.searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchWrapper>) {

    }

    class Coordinator: NSObject, UISearchBarDelegate {
        let textDidChange: PassthroughSubject<String, Never>
        
        init(changeClosure: PassthroughSubject<String, Never>)
        {
           textDidChange = changeClosure
        }
        func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String)
        {
//           textDidChange(searchText)
            textDidChange.send(searchText)
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            textDidChange.send("")
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

}
