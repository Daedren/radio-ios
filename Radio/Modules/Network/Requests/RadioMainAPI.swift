import Foundation

class RadioMainAPI: APIRequest {
    public typealias Response = RadioMainAPIResponseModel
    public var path: String {
        return "api"
    }
    public var method: HTTPMethod {
        return .get
    }

}
