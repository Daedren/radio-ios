
import Foundation
import Combine

public protocol MusicGateway {
    func play()
    func pause()
    func stop()
    func isPlaying() -> Bool
    func publishedIsPlaying() -> AnyPublisher<Bool, Never>
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String, Never>
    func getPlaybackInfo() -> AnyPublisher<PlaybackInfo, Never>
    func getScales() -> AnyPublisher<[Float], Never>
}

public class AVGatewayError: GatewayError {
    
}
