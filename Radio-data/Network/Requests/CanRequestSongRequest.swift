import Foundation

struct CanRequestSongRequest: APIRequest {
    public typealias Response = CanRequestSongResponseModel
    
    public var path: String {
        return "api/can-request"
    }

    public var method: HTTPMethod {
        return .get
    }

}
