import Foundation
import UIKit
import Combine
import Radio_Domain
import AVFoundation

public class AVGatewayImp: AVGateway {
    
    var audioClient: AVClient
    var remoteControl: RemoteControlClient
    
    let iOSCommands: [RemoteControlCommand] = [.togglePausePlay,
                                             .play,
                                             .pause,
                                             //            .nextTrack,
        //            .previousTrack,
        //            .skipBackward,
        //            .skipForward,
        //            .changePlaybackPosition,
        //            .changePlaybackRate,
    ]
    
    var nowPlayingDisposeBag = Set<AnyCancellable>()
    var classDisposeBag = Set<AnyCancellable>()
    var remote: AnyPublisher<RemoteControlCommand, Never>?
    
    init() {
        self.audioClient = AVClient()
        self.remoteControl = RemoteControlClient(registeredCommands: iOSCommands, disabledCommands: [])
        
        remoteControl.handleNowPlayableConfiguration()
        
        remoteControl
            .getRemoteController()
            .sink(receiveValue: { [weak self] command in
                switch command {
                case .play:
                    self?.play()
                case .pause:
                    self?.pause()
                default:
                    break
                }
            }).store(in: &classDisposeBag)
    }
    
    public func play() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: [.allowAirPlay, .allowBluetooth, .allowBluetoothA2DP])
        try? AVAudioSession.sharedInstance().setActive(true)
        audioClient.play()
        

    }
    
    public func pause() {
        self.nowPlayingDisposeBag = Set<AnyCancellable>()
        try? AVAudioSession.sharedInstance().setActive(false)
        
        audioClient.pause()
    }
    
    public func enqueue(url: URL) -> Bool {
        audioClient.enqueue(url: url)
    }
    
    public func getSongName() -> AnyPublisher<String, Never> {
        return audioClient.getSongName()
    }
    
}

extension AVGatewayImp {
    
    private func setReactiveHandlers() {
        self.nowPlayingDisposeBag = Set<AnyCancellable>()

        audioClient
            .getPlaybackInfo()
            .sink(receiveValue: { [weak self] metadata in
                if let playback = self?.createDynamicMetadata(from: metadata) {
                    self?.remoteControl.setPlayback(metadata: playback)
                }
            }).store(in: &nowPlayingDisposeBag)
        
        audioClient
            .getSongName()
            .sink(receiveValue: { [weak self] newName in
                if let metadata = self?.createStaticMetadata(with: newName) {
                    self?.remoteControl.setStatic(metadata: metadata)
                }
            }).store(in: &nowPlayingDisposeBag)
    }
    
    private func createStaticMetadata(with songName: String) -> RemoteControlStaticMetadata {
        let metadata = RemoteControlStaticMetadata(
            assetURL: URL(string: "http://r-a-d.io/assets/logo_image_small.png")!,
            mediaType: .audio,
            isLiveStream: true,
            title: songName,
            artist: "R/a/dio",
            artwork: nil,
            albumArtist: nil,
            albumTitle: nil)
        return metadata
    }
    
    private func createDynamicMetadata(from avMetadata: AVPlaybackInfo) -> NowPlayableDynamicMetadata {
        let metadata = NowPlayableDynamicMetadata(rate: avMetadata.rate,
                                                  position: avMetadata.position,
                                                  currentLanguageOptions: [],
                                                  availableLanguageOptionGroups: [])
        return metadata
    }
}
