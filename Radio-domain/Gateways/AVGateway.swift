
import Foundation
import Combine

public protocol AVGateway {
    func play()
    func pause()
    func stop()
    func isPlaying() -> Bool
    func publishedIsPlaying() -> AnyPublisher<Bool, Never>
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String, Never>
    func getPlaybackInfo() -> AnyPublisher<PlaybackInfo, Never>
}

public class AVGatewayError: GatewayError {
    
}
