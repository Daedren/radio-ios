import Foundation
import Combine
import AVFoundation

public protocol AVClientContract {
    func play()
    func pause()
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String,Never>
    func getPlaybackRate() -> Float
    func getPlaybackPosition() -> AnyPublisher<Float,Never>
}

public class AVClient: NSObject, AVClientContract {
    
    var manager: AVQueuePlayer
    var songName = PassthroughSubject<String,Never>()
    var position = PassthroughSubject<Float,Never>()

    var timeObserverToken: Any?

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
        self.position.send(Float(time.seconds))
    }
    
    public func getPlaybackRate() -> Float {
        return 1.0
    }
    
    public func getPlaybackPosition() -> AnyPublisher<Float,Never> {
        return self.position.eraseToAnyPublisher()
    }
    
}

extension AVClient: AVPlayerItemMetadataOutputPushDelegate {
    public func metadataOutput(_ output: AVPlayerItemMetadataOutput, didOutputTimedMetadataGroups groups: [AVTimedMetadataGroup], from track: AVPlayerItemTrack?) {
        print("output: \(output)")
        print("groups: \(groups)")
        print("track: \(String(describing: track))")
        
        if let group = groups.first, let item = group.items.first, let stringName = item.value as? String {
            self.songName.send(stringName)
        }
    }
}

