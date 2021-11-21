import Foundation

struct GetNewsRequest: APIRequest {
    public typealias Response = [GetNewsResponseModel]
    
    public var path: String {
        return "api/news"
    }

    public var method: HTTPMethod {
        return .get
    }

}
