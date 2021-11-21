import Foundation
import SwiftUI
import UIKit

public struct ListOptionViewModel: Identifiable, Equatable {
    public var id: Int
    var title: String
    var icon: String?
    
    public init(id: Int, title: String, icon: String?) {
        self.id = id
        self.title = title
        self.icon = icon
    }
    
    public static func stub() -> ListOptionViewModel {
        return ListOptionViewModel(id: 0, title: "aaa", icon: nil)
    }
}
