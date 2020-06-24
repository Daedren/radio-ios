import Foundation

struct GetFavoritesRequest: APIRequest {
    public typealias Response = [GetFavoritesResponseModel]
    
    var username: String
    
    public var path: String {
        return "faves/\(username)"
    }
    
    public var queryItems: [URLQueryItem]? {
        return [URLQueryItem(name: "dl", value: "true")]
    }
    
    public var method: HTTPMethod {
        return .get
    }

}
