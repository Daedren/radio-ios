
import Foundation
import Combine

public protocol AVGateway {
    func play()
    func pause()
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String, Never>
    func getPlaybackInfo() -> AnyPublisher<PlaybackInfo, Never>
}

public class AVGatewayError: GatewayError {
    
}
