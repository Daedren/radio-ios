import Foundation
import SwiftUI
import UIKit

struct ListOptionViewModel: Identifiable, Equatable {
    var id: Int
    var title: String
    var icon: String?
    
    
    static func stub() -> ListOptionViewModel {
        return ListOptionViewModel(id: 0, title: "aaa", icon: nil)
    }
}
