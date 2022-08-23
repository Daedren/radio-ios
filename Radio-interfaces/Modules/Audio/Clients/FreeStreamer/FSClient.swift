import Foundation
import Radio_cross
import Radio_interfaces
import FreeStreamer
import Combine

class FSClient: NSObject, Logging {
    var stream: FSAudioStream
    var url: URL?
    
    var isPlaying = CurrentValueSubject<Bool,Never>(false)
    var songName = PassthroughSubject<String,Never>()
    var position = PassthroughSubject<Float,Never>()
    var publisherRate = CurrentValueSubject<Float,Never>(0.0)
    var scale = PassthroughSubject<[Float],Never>()
    var analyzer = FSFrequencyDomainAnalyzer()

    init() {
        let configuration = FSStreamConfiguration()
        stream = FSAudioStream(configuration: configuration)
        
        super.init()
        stream.onMetaDataAvailable = handleMetadata(_:)
        stream.onStateChange = handleStateChanges(_:)
        stream.onFailure = handleErrors(_:_:)
        
        analyzer.delegate = self
        stream.delegate = analyzer
    }
    
    func handleMetadata(_ metadata: [AnyHashable: Any]?) {
        if let metadata = metadata,
            let trackInfo = metadata["StreamTitle"] as? String {
            self.songName.send(trackInfo)
        }
    }
    
    func handleStateChanges(_ newState: FSAudioStreamState) {
        switch newState {
        case .fsAudioStreamRetrievingURL:
            print(newState)
        case .fsAudioStreamStopped:
            print(newState)
        case .fsAudioStreamBuffering:
            print(newState)
        case .fsAudioStreamPlaying:
            print(newState)
        case .fsAudioStreamPaused:
            print(newState)
        case .fsAudioStreamSeeking:
            print(newState)
        case .fsAudioStreamEndOfFile:
            print(newState)
        case .fsAudioStreamFailed:
            print(newState)
        case .fsAudioStreamRetryingStarted:
            print(newState)
        case .fsAudioStreamRetryingSucceeded:
            print(newState)
        case .fsAudioStreamRetryingFailed:
            print(newState)
        case .fsAudioStreamPlaybackCompleted:
            print(newState)
        case .fsAudioStreamUnknownState:
            print(newState)
            break
        @unknown default:
            break
        }
    }
    
    func handleErrors(_ type: FSAudioStreamError, _ value: String?) {
        switch type {
        case .fsAudioStreamErrorNone:
            print(value)
        case .fsAudioStreamErrorOpen:
            print(value)
        case .fsAudioStreamErrorStreamParse:
            print(value)
        case .fsAudioStreamErrorNetwork:
            print(value)
        case .fsAudioStreamErrorUnsupportedFormat:
            print(value)
        case .fsAudioStreamErrorStreamBouncing:
            print(value)
        case .fsAudioStreamErrorTerminated:
            print(value)
        @unknown default:
            break
        }
        self.isPlaying.send(false)
    }
}


extension FSClient: FSFrequencyDomainAnalyzerDelegate {
    func frequenceAnalyzer(_ analyzer: FSFrequencyDomainAnalyzer!, levelsAvailable levels: UnsafeMutablePointer<Float>!, count: UInt) {
        var points = [Float]()
        let size = MemoryLayout<Float>.size
        for index in 0..<Int(count) {
           points.append(levels[index*size])
        }
        self.scale.send(points)
    }
}

extension FSClient: AudioClientContract {
    func play() {
        if let url = url {
            self.isPlaying.send(true)
            self.stream.play(from: url)
            self.analyzer.enabled = true
        }
    }
    
    func pause() {
            self.isPlaying.send(false)
        self.stream.pause()
    }
    
    func stop() {
            self.isPlaying.send(false)
        self.stream.stop()
    }
    
    func enqueue(url: URL) -> Bool {
        self.url = url
        return true
    }
    
    func getSongName() -> AnyPublisher<String, Never> {
        return self.songName.eraseToAnyPublisher()
    }
    
    func getPlaybackRate() -> Float {
        return self.isPlaying.value ? 1.0 : 0.0
    }
    
    func getPublisherPlaybackRate() -> AnyPublisher<Float, Never> {
        self.isPlaying
            .map{ $0 ? 1.0 : 0.0 }
            .eraseToAnyPublisher()
    }
    
    func getPlaybackPosition() -> AnyPublisher<Float, Never> {
        return Just(0.0).eraseToAnyPublisher()
    }
    
    func getLevels() -> AnyPublisher<[Float], Never> {
        return self.scale
            .print()
            .eraseToAnyPublisher()
    }

}
