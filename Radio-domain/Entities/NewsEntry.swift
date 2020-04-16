import Foundation

public struct NewsEntry {
    public var id: Int
    public var title: String
    public var text: String
    public var header: String
    public var author: String
    public var createdDate: Date
    public var modifiedDate: Date
    
    public init(id: Int, title: String, text: String, header: String, author: String, createdDate: Date, modifiedDate: Date) {
        self.id = id
        self.title = title
        self.text = text
        self.header = header
        self.author = author
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
