import Foundation

public struct GetFavoritesResponseModel: Decodable {
    var id: Int
    var name: String
    var lastrequested: Int?
    var lastplayed: Int?
    var requestcount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id = "tracks_id"
        case name = "meta"
        case lastrequested = "lastrequested"
        case lastplayed = "lastplayed"
        case requestcount = "requestcount"
    }
}
