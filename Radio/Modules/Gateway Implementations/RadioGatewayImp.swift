import Foundation
import Combine
import UIKit
import Radio_Domain
import Radio_cross

public class RadioGatewayImp: RadioGateway, LoggerWithContext {
    public var loggerInstance: LoggerWrapper
    
    var network: NetworkDispatcher
    var mapper: RadioMapper
    
    var allLastPlayed = NSMutableOrderedSet()
    
    var allTracks =  [Int : QueuedTrack]()
    
    var status = PassthroughSubject<RadioStatus,RadioError>()
    var currentTrack = PassthroughSubject<QueuedTrack,RadioError>()
    var queue = PassthroughSubject<[QueuedTrack],RadioError>()
    var lastPlayed = PassthroughSubject<[QueuedTrack],RadioError>()
    var currentDJ = PassthroughSubject<RadioDJ,RadioError>()
    
    var apiDisposeBag = Set<AnyCancellable>()
    var loopDisposeBag = Set<AnyCancellable>()
    var fetching = false
    
    public init(network: NetworkDispatcher,
                radioMapper: RadioMapper,
                logger: LoggerWrapper) {
        self.network = network
        self.mapper = radioMapper
        self.loggerInstance = logger
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoop), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoop), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    public func getCurrentTrack() -> AnyPublisher<QueuedTrack, RadioError> {
        return currentTrack.eraseToAnyPublisher()
    }
    
    public func getCurrentStatus() -> AnyPublisher<RadioStatus, RadioError> {
        return status.eraseToAnyPublisher()
    }
    
    public func getSongQueue() -> AnyPublisher<[QueuedTrack], RadioError> {
        return queue.eraseToAnyPublisher()
    }
    
    public func getLastPlayed() -> AnyPublisher<[QueuedTrack], RadioError> {
        return lastPlayed.eraseToAnyPublisher()
    }
    
    public func getCurrentDJ() -> AnyPublisher<RadioDJ, RadioError> {
        return currentDJ.eraseToAnyPublisher()
    }
    
    public func getTrackWith(identifier: String) -> QueuedTrack? {
        return self.allTracks[identifier.hashValue]
    }
    
    public func updateNow() {
        self.loggerDebug(message: "Update Now called")
        self.fetchFromAPI()
            .sink(receiveCompletion: { _ in },
                  receiveValue: {  _ in })
            .store(in: &apiDisposeBag)
    }
    
    public func searchFor(term: String) -> AnyPublisher<[SearchedTrack], RadioError> {
        return network.execute(request: SearchRequest(term: term))
            .tryMap(mapper.mapSearch(from:))
            .mapError{ _ in
                return RadioError.apiContentMismatch
        }
        .eraseToAnyPublisher()
    }
    
    public func request(songId: Int) -> AnyPublisher<Bool, RadioError> {
        return network.execute(request: GetTokenRequest())
            .flatMap{ [unowned self] token in
                self.network.execute(request: SongRequestRequest(id: songId, csrfToken: token))
            }
            .map{ response -> Bool in
                return (response.success != nil)
            }
            .mapError{ err in
                return RadioError.apiContentMismatch
            }
            .eraseToAnyPublisher()
    }
    
    public func getFavorites(for username: String) -> AnyPublisher<[FavoriteTrack], RadioError> {
        return network.execute(request: GetFavoritesRequest(username: username))
            .tryMap(mapper.mapFavorite(from:))
            .mapError{ err in
                return RadioError.apiContentMismatch
            }
            .eraseToAnyPublisher()
    }
    
}


extension RadioGatewayImp {
    private func startRecurringFetch() {
        self.loopDisposeBag = Set<AnyCancellable>()
        let timer = Timer.publish(every: 60.0, on: .current, in: .common)
            .autoconnect()
            .print()
            .eraseToAnyPublisher()
        
        let now = Just(Date())
        
        now
            .merge(with: timer)
            .setFailureType(to: RadioError.self)
            .flatMap { [unowned self] _ in
                self.fetchFromAPI()
        }
        .catch{ err in
            return Empty<RadioDetailedModel,Never>()
        }
        .sink(receiveValue: { _ in
        })
            .store(in: &loopDisposeBag)
        
    }
    
    @objc func stopLoop() {
        self.loggerDebug(message: "Loop to be stopped")
        self.loopDisposeBag = Set<AnyCancellable>()
    }
    
    @objc func resumeLoop() {
        self.loggerDebug(message: "Loop to be resumed")
        self.startRecurringFetch()
    }
    
    private func fetchFromAPI() -> AnyPublisher<RadioDetailedModel,RadioError>{
        if !fetching {
            self.fetching = true
            return self.network
                .execute(request: RadioMainAPI())
                .tryMap(self.mapper.map(from:))
                .handleEvents(receiveOutput: { [unowned self] model in
                    self.manageNewAPI(result: model)
                    self.fetching = false
                })
                .mapError{ error -> RadioError in
                    switch error {
                    case let radio_error as RadioError:
                        return radio_error
                    default:
                        return RadioError.unknown
                    }
            }
            .eraseToAnyPublisher()
        }
        return Empty<RadioDetailedModel,RadioError>(completeImmediately: true)
            .eraseToAnyPublisher()
        
    }
    
    
    private func manageNewAPI(result: RadioDetailedModel){
        for index in 0..<result.queue.count {
            var track = result.queue[index]
            if index+1 < result.queue.count {
                let nextTrack = result.queue[index+1]
                track.endTime = nextTrack.startTime
            }
            self.allTracks[track.hashValue] = track
        }
        self.allTracks[result.currentTrack.hashValue] = result.currentTrack
        
        self.currentDJ.send(result.dj)
        self.currentTrack.send(result.currentTrack)
        self.status.send(result.status)
        self.queue.send(result.queue)
        self.allLastPlayed.addObjects(from: result.lastPlayed.reversed())
        self.lastPlayed.send(Array(self.allLastPlayed.array.reversed()) as! [QueuedTrack] )
    }
}
