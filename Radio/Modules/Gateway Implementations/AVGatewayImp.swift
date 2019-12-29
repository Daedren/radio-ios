import Foundation
import UIKit
import Combine
import Radio_Domain
import AVFoundation

public class AVGatewayImp: AVGateway {
    
    var audioClient: AVClientContract
    
    var classDisposeBag = Set<AnyCancellable>()
    
    init() {
        self.audioClient = AVClient()
    }
    
    public func play() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
        try? AVAudioSession.sharedInstance().setActive(true)
        audioClient.play()
        
        
    }
    
    public func pause() {
        try? AVAudioSession.sharedInstance().setActive(false)
        audioClient.pause()
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
    
}
