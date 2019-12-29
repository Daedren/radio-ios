import Foundation

public class RadioRequestHandler {
    var globalHeaders: [String: String]
    private var baseSchemeAndAuthority: URL
    
    public init(globalHeaders: [String: String] = [:], baseSchemeAndAuthority: URL) {
        self.globalHeaders = globalHeaders
        self.baseSchemeAndAuthority = baseSchemeAndAuthority
    }
    
    func updateGlobal(headers: [String: String]) {
        self.globalHeaders.merge(headers, uniquingKeysWith: { _, b in return b})
    }
    
    func configureUrlRequest<T: APIRequest>(for request: T) -> URLRequest {
        // Endpoint
        let endpoint = self.endpoint(for: request)
        var urlRequest = URLRequest(url: endpoint)
        
        // Method and body
        urlRequest.httpMethod = request.method.rawValue
        if let bodyParams = request.bodyParams {
            urlRequest.httpBody = try? JSONEncoder().encode(bodyParams)
        }
        
        // Headers
        urlRequest = self.setAPIRequestHeaders(for: request, in: urlRequest)
        urlRequest = self.setGlobalHeaders(in: urlRequest)

        return urlRequest
    }
    
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        var base: URL?
        let custom = request.customSchemeAndAuthority
        if custom != nil {
            base = URL(string: custom!)
        } else {
            base = baseSchemeAndAuthority
        }
        guard let baseUrl = URL(string: request.path, relativeTo: base) else {
            fatalError("Bad resourceName: \(request.path)")
        }
        
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        components.queryItems = (request.queryItems)
        
        return components.url!
    }
    
    private func setAPIRequestHeaders<T: APIRequest>(for api: T, in request: URLRequest) -> URLRequest {
        var urlRequest = request
        
        if let headers = api.headers {
            for header in headers {
                urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
            }
        }
        
        return urlRequest
    }
    
    private func setGlobalHeaders(in request: URLRequest) -> URLRequest {
        var urlRequest = request
        for header in self.globalHeaders {
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        return urlRequest
    }
    
    private func prepareLanguageHeader() {
        
    }
    
}
