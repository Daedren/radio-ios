import Foundation

class SongRequestRequest: APIRequest {
    public typealias Response = EmptyResponseModel
    
    var songId: Int
    var csrfToken: String
    
    public var path: String {
        return "request/\(songId)"
    }
    public var method: HTTPMethod {
        return .post
    }

    public var contentType: HTTPContentType? {
        return .urlFormEncoded(body: "_token=\(csrfToken)")
    }
    
    init(id: Int, csrfToken: String){
        self.songId = id
        self.csrfToken = csrfToken
    }

}

struct SongRequestModel: Encodable {
    var token: String
    
    enum CodingKeys: String, CodingKey {
         case token = "_token"
     }
}
