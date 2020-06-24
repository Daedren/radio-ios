import Foundation

public struct GetNewsResponseModel: Decodable {
    let id: Int
    let title, text, header: String
    let userID: Int
    let deletedAt: String?
    let createdAt, updatedAt: String
    let isNewsPrivate: Int
    let author: AuthorResponseModel
    
    enum CodingKeys: String, CodingKey {
        case id, title, text, header
        case userID = "user_id"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case isNewsPrivate = "private"
        case author
    }
}

// MARK: - Author
struct AuthorResponseModel: Decodable {
    let id: Int
    let user: String
}
