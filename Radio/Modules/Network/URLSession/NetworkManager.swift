import Foundation
import Combine

public class RadioNetworkManager: NetworkDispatcher {
    
    var client: NetworkClient?
    var requestHandler: RadioRequestHandler
    var responseHandler: RadioResponseHandler
    
    public init(request: RadioRequestHandler, response: RadioResponseHandler, client: NetworkClient) {
        self.requestHandler = request
        self.responseHandler = response
        self.client = client
    }
    
    public func execute<T>(request: T) -> AnyPublisher<T.Response,APIError> where T: APIRequest {
        let urlRequest = self.getURLRequest(from: request)
        return self.sendRequestUpstream(apiRequest: request, request: urlRequest)
            .flatMap { [unowned self] (arg) -> Future<T.Response, APIError> in
                let (response, data) = arg
                do {
                    let r: T.Response = try self.getResponse(from: response, data: data, in: request)
                    return Future<T.Response,APIError>.init{ event in event(.success(r)) }
                }
                catch {
                    return Future<T.Response,APIError>.init{ event in event(.failure(.cannotDecodeResponse)) }
                }
        }
            .eraseToAnyPublisher()
    }

    // Request Handler
    //Err: none
    private func getURLRequest<T>(from apiRequest: T) -> URLRequest where T: APIRequest {
        requestHandler.configureUrlRequest(for: apiRequest)
    }
    
    //Response Handler
    private func getResponse<T>(from urlResponse: URLResponse?, data: Data?, in request: T) throws -> T.Response where T: APIRequest {
        
        let response = try responseHandler.getResponse(from: data, response: urlResponse, toType: T.Response.self)
            return response
    }
    
    // Network
    private func sendRequestUpstream<T>(apiRequest: T, request: URLRequest) -> Future<(URLResponse?, Data?), APIError> where T: APIRequest {
        
        guard let client = self.client else {
            return Future<(URLResponse?, Data?), APIError> {
                $0(.failure(.technicalError))
            }
        }
        
        if let file = apiRequest.fileToUpload {
            return client
                .uploadFile(file: file, url: request)
        } else {
            return client
                .performRequest(request: request)
        }
    }

}
