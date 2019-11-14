import Foundation
import Combine
import AVFoundation

public class AVClient: NSObject {
    
    var manager: AVQueuePlayer
    var songName = PassthroughSubject<String,Never>()
    
    var timeObserverToken: Any?
    var playbackInfo = PassthroughSubject<AVPlaybackInfo,Never>()
    
    public override init() {
        self.manager = AVQueuePlayer()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
    }
    
    public func play() {
        self.manager.play()
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 5.0, preferredTimescale: timeScale)
        self.timeObserverToken = self.manager.addPeriodicTimeObserver(
            forInterval: time,
            queue: DispatchQueue.global(qos: .background),
            using: updatePlaybackInfo(with:))
        
    }
    
    public func pause() {
        self.manager.pause()
        if let token = self.timeObserverToken {
            self.manager.removeTimeObserver(token)
            self.timeObserverToken = nil
        }
    }
    
    public func enqueue(url: URL) -> Bool {
        let item = AVPlayerItem(url: url)
        item.add(createMetadataOutput())
        
        if manager.canInsert(item, after: nil) {
            self.manager.insert(item, after: nil)
            return true
        }
        
        return false
    }
    
    public func getSongName() -> AnyPublisher<String,Never> {
        return songName.eraseToAnyPublisher()
    }
    
    public func getPlaybackInfo() -> AnyPublisher<AVPlaybackInfo,Never> {
        return self.playbackInfo.eraseToAnyPublisher()
    }
    
    private func createMetadataOutput() -> AVPlayerItemMetadataOutput{
        let metadataOutput = AVPlayerItemMetadataOutput()
        metadataOutput.setDelegate(self, queue: DispatchQueue.global(qos: .default))
        return metadataOutput
    }
    
    @objc func itemFailedToPlayToEndTime(_ notification: Notification) {
        print("\(notification.debugDescription)")
    }
    @objc func itemPlaybackStalled(_ notification: Notification) {
        print("\(notification.debugDescription)")
    }
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        print("\(notification.debugDescription)")
    }
    
    private func updatePlaybackInfo(with time: CMTime) {
//        print("Updating time at \(time)")
        self.playbackInfo.send(
            AVPlaybackInfo(rate: 1.0,
                           position: Float(time.seconds))
        )
    }
    
}

extension AVClient: AVPlayerItemMetadataOutputPushDelegate {
    public func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        print("output: \(output)")
        print("groups: \(groups)")
        print("track: \(track)")
        
        if let group = groups.first, let item = group.items.first, let stringName = item.value as? String {
            self.songName.send(stringName)
        }
    }
}

