import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var customSchemeAndAuthority: String? { get }
    
    var fileToUpload: URL? { get }
    var contentType: HTTPContentType? { get }
}

extension APIRequest {
     public var method: HTTPMethod { return .get }
     public var queryItems: [URLQueryItem]? { return nil }
     public var headers: [String: String]? { return nil }
     public var fileToUpload: URL? { return nil }
     public var customSchemeAndAuthority: String? { return nil }
     public var contentType: HTTPContentType? { return nil }
}

public enum HTTPMethod: String {
    case get, post, put, patch, delete, head
}

public enum HTTPContentType {
    case json(body: AnyEncodable?)
    case urlFormEncoded(body: String?)
    
    var headerString: String {
        switch self {
        case .json(body: _):
            return "application/json"
        case .urlFormEncoded(body: _):
            return "application/x-www-form-urlencoded"
        }
    }
}
