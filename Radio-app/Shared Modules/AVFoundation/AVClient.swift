import Foundation
import Combine
import AVFoundation
import Radio_cross

public protocol AudioClientContract {
    func play()
    func pause()
    func stop()
    func enqueue(url: URL) -> Bool
    func getSongName() -> AnyPublisher<String,Never>
    func getPlaybackRate() -> Float
    func getPublisherPlaybackRate() -> AnyPublisher<Float,Never>
    func getPlaybackPosition() -> AnyPublisher<Float,Never>
    func getLevels() -> AnyPublisher<[Float],Never>
}

// Optional functions for the contract
extension AudioClientContract {
    public func getLevels() -> AnyPublisher<[Float],Never> {
        return Empty().eraseToAnyPublisher()
    }
}

public class AVClient: NSObject, AudioClientContract, LoggerWithContext {
    public var loggerInstance: LoggerWrapper
    
    
    var manager: AVQueuePlayer
    var songName = PassthroughSubject<String,Never>()
    var position = PassthroughSubject<Float,Never>()
    var publisherRate = CurrentValueSubject<Float,Never>(0.0)
    private var kvoObserver: NSKeyValueObservation?

    var timeObserverToken: Any?

    public init(
        logger: LoggerWrapper
    ) {
        self.loggerInstance = logger
        self.manager = AVQueuePlayer()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
        self.kvoObserver = self.manager.observe(\.rate, options: .new) { [weak self] (manager, change) in
            guard let nextRate = change.newValue else { return }
            self?.publisherRate.send(nextRate)
        }
    }
    
    deinit {
        kvoObserver?.invalidate()
    }
    
    public func play() {
        if let item = self.manager.currentItem,
            let bufferedValue = item.loadedTimeRanges.first as? CMTimeRange
            {
            let bufferedTime = bufferedValue.duration + bufferedValue.start
            let current = item.currentTime()
            let seconds = CMTimeGetSeconds(bufferedTime - current)
            print("Buffered time is \(seconds)")
        }
        
        if let timeObserverToken = self.timeObserverToken {
            self.manager.removeTimeObserver(timeObserverToken)
        }
        
        self.manager.play()
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 5.0, preferredTimescale: timeScale)
        self.timeObserverToken = self.manager.addPeriodicTimeObserver(
            forInterval: time,
            queue: DispatchQueue.global(qos: .background),
            using: updatePlaybackInfo(with:))
        
    }
    
    public func pause() {
        self.manager.rate = 0.0
//        self.manager.removeAllItems()
        if let token = self.timeObserverToken {
            self.manager.removeTimeObserver(token)
            self.timeObserverToken = nil
        }
    }
    
    public func stop() {
        self.manager.removeAllItems()
        self.manager.rate = 0.0
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
        self.loggerInfo(message: "\(notification.debugDescription)")
    }
    @objc func itemPlaybackStalled(_ notification: Notification) {
        self.loggerInfo(message: "\(notification.debugDescription)")
    }
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        self.loggerInfo(message: "\(notification.debugDescription)")
    }
    
    private func updatePlaybackInfo(with time: CMTime) {
        if let currentItem = manager.currentItem {
            self.loggerInfo(message: "\(currentItem.canStepForward) \(currentItem.forwardPlaybackEndTime) \(currentItem.seekableTimeRanges)")
        }
        self.position.send(Float(time.seconds))
    }
    
    public func getPlaybackRate() -> Float {
        return self.manager.rate
    }
    
    public func getPlaybackPosition() -> AnyPublisher<Float,Never> {
        return self.position.eraseToAnyPublisher()
    }
    
    public func getPublisherPlaybackRate() -> AnyPublisher<Float,Never> {
        return self.publisherRate.eraseToAnyPublisher()
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

