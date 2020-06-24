import Foundation
import Combine

public protocol NetworkDispatcher {
    func execute<T: APIRequest>(request: T) -> AnyPublisher<T.Response,APIError>
}

public protocol NetworkClient {
    func performRequest(request: URLRequest) -> Future<(URLResponse?, Data?), APIError>
    func uploadFile(file: URL, url: URLRequest) -> Future<(URLResponse?, Data?), APIError>
}

public struct EmptyResponseModel: Decodable { }

public struct AnyEncodable: Encodable {
    let value: Encodable

    public func encode(to encoder: Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

public enum APIError: Error {
    case httpError(code: Int)
    case requestTimedOut
    case noInternet
    case invalidCertificate
    case jsonParsingError
    case mockNotFound
    case unsuccessfulResponse
    case otherError
    
    case cannotDecodeResponse
    case technicalError
}
