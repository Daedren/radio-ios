import Foundation
import UIKit
import SwiftUI
import Combine

public struct SearchWrapper: UIViewRepresentable {
    public typealias UIViewType = UISearchBar
    let searchBar = UISearchBar()
    let placeholder: String?
    let textDidChange: PassthroughSubject<String, Never>
    
    public init(placeholder: String?, textDidChange: PassthroughSubject<String, Never>) {
        self.placeholder = placeholder
        self.textDidChange = textDidChange
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(changeClosure: textDidChange)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<SearchWrapper>) -> UISearchBar {
        self.searchBar.delegate = context.coordinator
        self.searchBar.placeholder = self.placeholder
        return self.searchBar
    }

    public func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchWrapper>) {

    }

    public class Coordinator: NSObject, UISearchBarDelegate {
        let textDidChange: PassthroughSubject<String, Never>
        
        init(changeClosure: PassthroughSubject<String, Never>)
        {
           textDidChange = changeClosure
        }
        public func searchBar(_ searchBar: UISearchBar,
                       textDidChange searchText: String)
        {
//           textDidChange(searchText)
            textDidChange.send(searchText)
        }
        
        public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(true, animated: true)
        }
        
        public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.setShowsCancelButton(false, animated: true)
        }
        
        public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            textDidChange.send("")
            searchBar.resignFirstResponder()
        }
        
        public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

}
