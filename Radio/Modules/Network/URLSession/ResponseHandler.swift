import Foundation
import SwiftSoup

public class RadioResponseHandler {
    
    public init() {}
    
    func getResponse<T>(from data: Data?, response: URLResponse?, toType: T.Type) throws -> T where T: Decodable {
        do {
            if let httpResponse = response as? HTTPURLResponse,
                let contentType = httpResponse.allHeaderFields["Content-Type"] as? String,
                let data = data,
                !data.isEmpty {
                let netResponse = try self.decode(sourceMime: contentType, data: data, type: T.self)
                
                return netResponse
            }
            throw APIError.otherError
        } catch {
            throw APIError.cannotDecodeResponse
        }
    }
    
    private func decode<T>(sourceMime: String, data: Data, type: T.Type) throws -> T where T: Decodable {
        if sourceMime.starts(with: "application/json") {
            return try JSONDecoder().decode(T.self, from: data)
        }
        if sourceMime.starts(with: "text/html") {
            return try self.decodeHTML(selector: "input[name='_token']", data: String(data: data, encoding: .utf8) ?? "") as! T
        }
        throw APIError.cannotDecodeResponse
    }
    
    private func decodeHTML(selector: String, data: String) throws -> String {
        let document = try SwiftSoup.parse(data)
        let item = try document.select(selector)
        return try item.val()
    }
    
}
