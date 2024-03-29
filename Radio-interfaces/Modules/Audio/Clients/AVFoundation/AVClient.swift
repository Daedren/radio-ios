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

public class AVClient: NSObject, AudioClientContract, Logging {
    
    
    var manager: AVQueuePlayer
    var songName = PassthroughSubject<String,Never>()
    var position = PassthroughSubject<Float,Never>()
    var publisherRate = CurrentValueSubject<Float,Never>(0.0)
    private var kvoObserver: NSKeyValueObservation?

    var timeObserverToken: Any?

    public override init() {
        self.manager = AVQueuePlayer()
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(itemFailedToPlayToEndTime(_:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemNewErrorLogEntry(_:)), name: .AVPlayerItemNewErrorLogEntry, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(itemPlaybackStalled(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: AVAudioSession.sharedInstance())
        self.kvoObserver = self.manager.observe(\.rate, options: .new) { [weak self] (manager, change) in
            guard let nextRate = change.newValue else { return }
            self?.publisherRate.send(nextRate)
        }
    }
    
    deinit {
        kvoObserver?.invalidate()
    }

    // MARK: Public methods
    
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

    private func updatePlaybackInfo(with time: CMTime) {
        if let currentItem = manager.currentItem {
            self.log(message: "\(currentItem.canStepForward) \(currentItem.forwardPlaybackEndTime) \(currentItem.seekableTimeRanges)", logLevel: .info)
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

    // MARK: Notification handlers

    @objc func itemFailedToPlayToEndTime(_ notification: Notification) {
        self.log(message: "\(notification.debugDescription)", logLevel: .info)
    }
    @objc func itemPlaybackStalled(_ notification: Notification) {
        self.log(message: "\(notification.debugDescription)", logLevel: .info)
    }
    @objc func itemNewErrorLogEntry(_ notification: Notification) {
        self.log(message: "\(notification.debugDescription)", logLevel: .info)
    }
    @objc func handleRouteChange(_ notification: Notification) {
        self.log(message: "\(notification.debugDescription)", logLevel: .info)
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
                let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
        }
        switch reason {
        case .newDeviceAvailable:
            let session = AVAudioSession.sharedInstance()
            let portsWeCareFor: [AVAudioSession.Port] = [.headphones, .bluetoothA2DP]
            let newPorts = session.currentRoute.outputs.map{ $0.portType }
            self.log(message: String(describing: session.currentRoute.outputs), logLevel: .info)
            if self.manager.rate == 0.0 && newPorts.contains(where: portsWeCareFor.contains) {
                self.play()
            }
        case .oldDeviceUnavailable:
            // AVPlayer auto handles these cases.
            break
        default:
            break
        }
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

