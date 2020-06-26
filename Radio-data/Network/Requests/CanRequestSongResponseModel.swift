import Foundation

public struct CanRequestSongResponseModel: Decodable {
    let main: CanRequestSongResponseMainModel
    
    enum CodingKeys: String, CodingKey {
        case main
    }
}

// MARK: - Author
struct CanRequestSongResponseMainModel: Decodable {
    let requests: Bool
    
    enum CodingKeys: String, CodingKey {
        case requests
    }
}
