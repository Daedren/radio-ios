import Foundation
import Combine

public protocol NetworkDispatcher {
    func execute<T: APIRequest>(request: T) -> AnyPublisher<T.Response,APIError>
}

public struct AnyEncodable: Encodable {
    let value: Encodable

    public func encode(to encoder: Encoder) throws {
        try self.value.encode(to: encoder)
    }
}

public enum APIError: Error {
    case httpError(code: Int, message: String)
    case requestTimedOut
    case noInternet
    case invalidCertificate
    case jsonParsingError
    case mockNotFound
    case cannotMapToEntity
    case unsuccessfulResponse
    case otherError
}
