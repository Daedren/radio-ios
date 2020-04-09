import Foundation
import Combine
import UIKit
import Radio_Domain

public class RadioGatewayImp: RadioGateway {
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
    var fetching = false
    
    public init(network: NetworkDispatcher, radioMapper: RadioMapper) {
        self.network = network
        self.mapper = radioMapper
        
        self.startRecurringFetch()
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
    
    public func request(songId: Int) -> AnyPublisher<(), RadioError> {
        return network.execute(request: GetTokenRequest())
            .flatMap{ [unowned self] token in
                return self.network.execute(request: SongRequestRequest(id: songId, csrfToken: token))
        }
        .mapError{ _ in
            return RadioError.apiContentMismatch
        }
        .map{ _ in
            return ()
        }
        .eraseToAnyPublisher()
    }
    
}


extension RadioGatewayImp {
    private func startRecurringFetch() {
        let timer = Timer.publish(every: 20.0, on: .current, in: .common)
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
        .sink(receiveValue: { evt in
            print(evt)
        })
            .store(in: &apiDisposeBag)
        
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
        return Empty<RadioDetailedModel,RadioError>().eraseToAnyPublisher()
        
    }
    
    private func manageNewAPI(result: RadioDetailedModel){
        self.allTracks[result.currentTrack.hashValue] = result.currentTrack
        for track in result.queue {
            self.allTracks[track.hashValue] = track
        }
        
        self.currentDJ.send(result.dj)
        self.currentTrack.send(result.currentTrack)
        self.status.send(result.status)
        self.queue.send(result.queue)
        self.allLastPlayed.addObjects(from: result.lastPlayed.reversed())
        self.lastPlayed.send(Array(self.allLastPlayed.array.reversed()) as! [QueuedTrack] )
        
    }
}
