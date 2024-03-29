import Foundation
import Combine
import UIKit
import Radio_domain
import Radio_cross

public class RadioGatewayImp: RadioGateway, Logging {
    var network: NetworkDispatcher
    var mapper: RadioMapper
    
    var allLastPlayed = NSMutableOrderedSet()
    
    var allTracks =  [Int : QueuedTrack]()
    
    var status = CurrentValueSubject<RadioStatus?,RadioError>(nil)
    var currentTrack = PassthroughSubject<QueuedTrack,RadioError>()
    var queue = CurrentValueSubject<[QueuedTrack]?,RadioError>(nil)
    var lastPlayed = PassthroughSubject<[QueuedTrack],RadioError>()
    var currentDJ = PassthroughSubject<RadioDJ,RadioError>()
    
    var apiDisposeBag = Set<AnyCancellable>()
    var loopDisposeBag = Set<AnyCancellable>()
    var fetching = false
    
    public init(network: NetworkDispatcher,
                radioMapper: RadioMapper) {
        self.network = network
        self.mapper = radioMapper
        
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(stopLoop), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resumeLoop), name: UIApplication.didBecomeActiveNotification, object: nil)
        #endif

//        if Bundle.main.bundlePath.hasSuffix(".appex") {
//            self.updateNow()
//        }
//        #endif
//
//        self.log(message: "Running as \(Bundle.main.bundlePath)")

        #if os(watchOS)
        self.startRecurringFetch()
        #endif
    }
    
    public func getCurrentTrack() -> AnyPublisher<QueuedTrack, RadioError> {
        return currentTrack.eraseToAnyPublisher()
    }
    
    public func getCurrentStatus() -> AnyPublisher<RadioStatus, RadioError> {
        return status
            .compactMap{ $0 }
            .eraseToAnyPublisher()
    }
    
    public func getSongQueue() -> AnyPublisher<[QueuedTrack], RadioError> {
        return queue
            .compactMap{ $0 }
            .eraseToAnyPublisher()
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
    
    public func updateNow() -> AnyPublisher<Void, RadioError> {
        self.log(message: "Update Now called", logLevel: .debug)
        return self.fetchFromAPI()
            .map { _ in return () }
            .eraseToAnyPublisher()
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
            .flatMap { [unowned self] token in
                    self.network.execute(request: SongRequestRequest(id: songId, csrfToken: token))
            }
            .mapError{ err in
                return RadioError.apiContentMismatch
            }
            .flatMap { response -> AnyPublisher<Bool, RadioError> in
                if let err = response.error, !err.isEmpty {
                    return Fail(error: RadioError.errorWithReason(err))
                    .eraseToAnyPublisher()
                }
                return Just(response.success != nil)
                    .setFailureType(to: RadioError.self)
                    .eraseToAnyPublisher()
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
    
    public func getNews() -> AnyPublisher<[NewsEntry], RadioError> {
        return network.execute(request: GetNewsRequest())
            .tryMap(mapper.mapNews(from:))
            .mapError{ err in
                return RadioError.apiContentMismatch
        }
        .eraseToAnyPublisher()
    }
    
    public func canRequestSong() -> AnyPublisher<Bool, RadioError> {
        return network.execute(request: CanRequestSongRequest())
            .map{ $0.main.requests }
            .mapError{ err in
                return RadioError.apiContentMismatch
        }
        .eraseToAnyPublisher()
    }
    
}


extension RadioGatewayImp {
    private func startRecurringFetch() {
        self.loopDisposeBag = Set<AnyCancellable>()
        let timer = Timer.publish(every: 60.0,
                                  tolerance: 5.0,
                                  on: .current,
                                  in: .common)
            .autoconnect()
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
        self.log(message: "Loop to be stopped", logLevel: .debug)
        self.loopDisposeBag = Set<AnyCancellable>()
    }
    
    @objc func resumeLoop() {
        self.log(message: "Loop to be resumed", logLevel: .debug)
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
