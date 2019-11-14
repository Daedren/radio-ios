
import Foundation
import Combine

public protocol AVGateway {
    func play()
    func pause()
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String, Never>
}

public class AVGatewayError: GatewayError {
    
}
