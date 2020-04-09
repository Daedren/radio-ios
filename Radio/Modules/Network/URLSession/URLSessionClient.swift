import Foundation
import Combine
import Radio_cross

public class URLSessionClient: NetworkClient, LoggerWithContext {
    public var loggerInstance: LoggerWrapper
    
    private var session = URLSession(configuration: .default)
    
    public init(configuration: URLSessionConfiguration? = nil,
                logger: LoggerWrapper) {
        if let configuration = configuration {
            self.session = URLSession(configuration: configuration)
        }
        self.loggerInstance = logger
    }
    
    public func performRequest(request: URLRequest) -> Future<(URLResponse?, Data?), APIError> {
        self.data(urlRequest: request)
    }
    
    public func uploadFile(file: URL, url: URLRequest) -> Future<(URLResponse?, Data?), APIError> {
        self.upload(file: file, urlRequest: url)
    }
    
}

extension URLSessionClient {
    
    private func data(urlRequest: URLRequest) -> Future<(URLResponse?, Data?), APIError> {
        return Future<(URLResponse?, Data?), APIError> { [weak self] event in
            
            let task = self?.session.dataTask(with: urlRequest) { [weak self] data, response, error in
                do {
                    if let result = try self?.requestHandler(data: data, response: response, error: error) {
                        event(.success(result))
                    }
                } catch {
                    event(.failure(APIError.otherError))
                }
            }
            task?.resume()
        }
    }
    
    private func upload(file: URL, urlRequest: URLRequest) -> Future<(URLResponse?, Data?), APIError> {
        return Future<(URLResponse?, Data?), APIError> { [weak self] event in
            
            let task = self?.session.uploadTask(with: urlRequest, fromFile: file) { data, response, error in
                do {
                    if let result = try self?.requestHandler(data: data, response: response, error: error) {
                        event(.success(result))
                    }
                } catch {
                    event(.failure(APIError.otherError))
                }
            }
            task?.resume()
        }
    }
    
    private func requestHandler(data: Data?, response: URLResponse?, error: Error?) throws -> (URLResponse?, Data?) {
//        self.loggerVerbose(message: "\(String(describing: response))")
//        self.loggerVerbose(message: "\(String(describing: String(data: data ?? Data(), encoding: .utf8)))")
//        self.loggerVerbose(message: "\(String(describing: error))")
        
        if let error = error {
            let errorCode = error as NSError
            switch errorCode.code {
            case NSURLErrorTimedOut:
                throw APIError.requestTimedOut
            case NSURLErrorServerCertificateUntrusted:
                throw APIError.invalidCertificate
            case NSURLErrorNotConnectedToInternet:
                throw APIError.noInternet
            default:
                throw APIError.otherError
            }
        }
        
        return (response, data)
    }
}
