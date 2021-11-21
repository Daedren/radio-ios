import Foundation
import UIKit
import SwiftUI

public class AppAttributedString {
    var value: NSMutableAttributedString

    public init(value: NSMutableAttributedString) {
        self.value = value
        let col = UIColor(RadioColors.label)
        value.addAttributes([NSAttributedString.Key.foregroundColor: col,
                             NSAttributedString.Key.font:UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current)],
                            range: NSRange(location: 0, length: value.length))
    }
}
