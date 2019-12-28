import Foundation

public class RadioResponseHandler {
    
    public init() {}
    
    func getResponse<T>(from data: Data?, response: URLResponse?, toType: T.Type) throws -> T where T: Decodable {
        do {
            if let data = data, !data.isEmpty {
                let netResponse = try self.decode(data: data, type: T.self)
                
                return netResponse
            }
            throw APIError.otherError
        } catch {
            throw APIError.cannotDecodeResponse
        }
    }
    
    private func decode<T>(data: Data, type: T.Type) throws -> T where T: Decodable {
        return try JSONDecoder().decode(T.self, from: data)
    }
    
}
