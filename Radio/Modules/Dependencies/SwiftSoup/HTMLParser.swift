import Foundation
protocol HTMLParser {
    func parse(htmlString: String) -> NSMutableAttributedString?
}

class DataHTMLParser: HTMLParser {
    func parse(htmlString: String) -> NSMutableAttributedString? {
        do {
            let optionalData = htmlString.data(using: .utf8)
            if let data = optionalData,
                let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                return attributedString
            }
        }
        return nil
    }
}
