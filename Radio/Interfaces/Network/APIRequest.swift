import Foundation

public protocol APIRequest {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var bodyParams: AnyEncodable? { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var customSchemeAndAuthority: String? { get }
    
    var fileToUpload: URL? { get }
}

extension APIRequest {
     public var method: HTTPMethod { return .get }
     public var bodyParams: AnyEncodable? { return nil }
     public var queryItems: [URLQueryItem]? { return nil }
     public var headers: [String: String]? { return nil }
     public var fileToUpload: URL? { return nil }
     public var customSchemeAndAuthority: String? { return "asd" }
}

public enum HTTPMethod: String {
    case get, post, put, patch, delete, head
}
