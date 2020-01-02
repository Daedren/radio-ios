import Foundation

public struct SearchResponseModel: Decodable {
    let total, perPage, currentPage, lastPage: Int
    let from, to: Int
    let data: [SearchedTrackResponseModel]
    
    enum CodingKeys: String, CodingKey {
        case total
        case perPage = "per_page"
        case currentPage = "current_page"
        case lastPage = "last_page"
        case from, to, data
    }
}

struct SearchedTrackResponseModel: Decodable {
    let artist, title: String
    let id, lastplayed, lastrequested: Int
    let requestable: Bool
}
