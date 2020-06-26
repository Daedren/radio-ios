import SwiftUI

extension View {
    
    /// Sets the style for lists within this view.
    public func styledList() -> some View {
        self.modifier(StyledList())
    }
    
}

struct StyledList: ViewModifier {
    func body(content: Content) -> some View {
//        if #available(iOS 14.0, macCatalyst 14, *) {
//            return content
//                .listStyle(InsetGroupedListStyle())
//        } else {
//            return content
//                .listStyle(DefaultListStyle())
//        }
        return content.listStyle(GroupedListStyle())
    }
}
