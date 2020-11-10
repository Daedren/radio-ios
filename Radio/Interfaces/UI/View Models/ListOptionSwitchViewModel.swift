import Foundation
import UIKit

struct ListOptionSwitchViewModel: Identifiable, Equatable {
    var id: Int
    var title: String
    var icon: String?
    var isOn: Bool
    
    
    static func stub() -> ListOptionSwitchViewModel {
        return ListOptionSwitchViewModel(id: 0, title: "aaa", icon: nil, isOn: false)
    }
}
