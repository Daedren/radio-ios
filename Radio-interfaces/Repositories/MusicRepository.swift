import Foundation
import UIKit
import Combine
import Radio_domain
import Radio_cross
import AVFoundation

public class MusicRepository: MusicGateway {
    
    var audioClient: AudioClientContract
    
    var classDisposeBag = Set<AnyCancellable>()
    
    var categoryOptions: AVAudioSession.CategoryOptions
    
    public init(logger: LoggerWrapper, client: AudioClientContract) {
        self.audioClient = client
        
        #if os(iOS)
            self.categoryOptions = [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP]
        #endif
        
        #if os(watchOS)
            self.categoryOptions = [.allowBluetoothA2DP]
        #endif
    }
    
    public func play() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: self.categoryOptions)
        try? AVAudioSession.sharedInstance().setActive(true)
        audioClient.play()
        
        
    }
    
    public func pause() {
        try? AVAudioSession.sharedInstance().setActive(false)
        audioClient.pause()
    }
    
    public func stop() {
        try? AVAudioSession.sharedInstance().setActive(false)
        audioClient.stop()
    }
    
    public func enqueue(url: URL) -> Bool {
        audioClient.enqueue(url: url)
    }
    
    public func getSongName() -> AnyPublisher<String, Never> {
        return audioClient.getSongName()
    }
    
    public func getPlaybackInfo() -> AnyPublisher<PlaybackInfo, Never> {
        return audioClient.getPlaybackPosition()
            .map{ position in
                return PlaybackInfo(position: position)
        }
        .eraseToAnyPublisher()
    }
    
    public func isPlaying() -> Bool {
        return audioClient.getPlaybackRate() > 0.0
    }
    
    public func publishedIsPlaying() -> AnyPublisher<Bool, Never> {
        return self.audioClient.getPublisherPlaybackRate()
            .map{ return $0 > 0.0 }
            .eraseToAnyPublisher()
    }
    
    public func getScales() -> AnyPublisher<[Float], Never> {
        return audioClient.getLevels()
    }
    
}
