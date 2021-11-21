import Foundation
import UIKit

public class AppAttributedString {
    var value: NSMutableAttributedString

    public init(value: NSMutableAttributedString) {
        self.value = value
        value.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.label,
                             NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current)],
                            range: NSRange(location: 0, length: value.length))
    }
}
