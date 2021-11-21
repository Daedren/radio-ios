import Foundation

public protocol HTMLParser {
    func parse(htmlString: String) -> NSMutableAttributedString?
}

public class DataHTMLParser: HTMLParser {
    
    public init() { }
    
    public func parse(htmlString: String) -> NSMutableAttributedString? {
        do {
            let optionalData = htmlString.data(using: .utf16)
            if let data = optionalData,
                let attributedString = try? NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                return attributedString
            }
        }
        return nil
    }
}
    
