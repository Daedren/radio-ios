import Foundation

public struct SongRequestResponseModel: Decodable {
    let error: String?
    let success: String?

    enum CodingKeys: String, CodingKey {
        case error = "error"
        case success = "success"
    }
}
