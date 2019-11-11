import Foundation
import Combine
import AVFoundation

public class AVClient: NSObject {
    
    var manager: AVQueuePlayer
    var songName = PassthroughSubject<String,Never>()
    
    public override init() {
        self.manager = AVQueuePlayer()
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
    }
    
    public func play() {
        try? AVAudioSession.sharedInstance().setCategory(.playback, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        self.manager.play()
    }
    
    public func pause() {
        try? AVAudioSession.sharedInstance().setActive(false)
        self.manager.pause()
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

