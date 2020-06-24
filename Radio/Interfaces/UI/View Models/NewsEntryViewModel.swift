import Foundation
import UIKit

struct NewsEntryViewModel: Identifiable {
    var id: Int

    var title: String
    var body: AppAttributedString
//    var header: String
    var createdAt: Date
    var author: String
 
    static func stub() -> NewsEntryViewModel {
        let attributedString = NSMutableAttributedString(string: "This is a sample news post.\n")

        let attributes1: [NSAttributedString.Key : Any] = [
           .font: UIFont(name: "HelveticaNeue-Bold", size: 13)!
        ]
        attributedString.addAttributes(attributes1, range: NSRange(location: 10, length: 6))

        let attributes3: [NSAttributedString.Key : Any] = [
           .font: UIFont(name: "HelveticaNeue-Light", size: 13)!
        ]
        attributedString.addAttributes(attributes3, range: NSRange(location: 17, length: 9))
        
        return NewsEntryViewModel(id: 1,
                                  title: "Random news title",
                                  body: AppAttributedString(value: attributedString),
                                  createdAt: Date(),
                                  author: "Me")
    }
}
