import Foundation
import Combine

public class FakeNetworkClient: NetworkDispatcher {
    
    public init() {}
    
    public func execute<T>(request: T) -> AnyPublisher<T.Response,APIError> where T: APIRequest {
        let request = Future<T.Response,APIError>.init{ event in
            
            let fileLocation = String(describing: T.self)+"Fake"
            if let filePath = Bundle(for: type(of: self))
                .path(forResource: fileLocation,
                      ofType: "json") {
                do {
                    let url = URL(fileURLWithPath: filePath)
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    
                    var modelData: T.Response?
                    let decoded = try decoder.decode(T.Response.self, from: data)
                    modelData = decoded
                    event(.success(modelData!))
                } catch {
                    print(error)
                    event(.failure(APIError.jsonParsingError(error)))
                }
            } else {
                print(fileLocation)
                event(.failure(APIError.mockNotFound))
            }
        }
        
        let delayedRequest = request.delay(for: .seconds(3.0), scheduler: RunLoop.main)
        return delayedRequest.eraseToAnyPublisher()
    }
}
