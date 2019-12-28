import Foundation
import Combine
import UIKit
import Radio_Domain

public class RadioGatewayImp: RadioGateway {
    
    var network: NetworkDispatcher
    var mapper: RadioMapper
    
    var status = PassthroughSubject<RadioStatus,RadioError>()
    var currentTrack = PassthroughSubject<Track,RadioError>()
    var queue = PassthroughSubject<[Track],RadioError>()
    var lastPlayed = PassthroughSubject<[Track],RadioError>()
    var currentDJ = PassthroughSubject<RadioDJ,RadioError>()
    
    var apiDisposeBag = Set<AnyCancellable>()
    
    public init(network: NetworkDispatcher, radioMapper: RadioMapper) {
        self.network = network
        self.mapper = radioMapper
        
        self.fetchFromAPI()
    }
    
    public func getCurrentTrack() -> AnyPublisher<Track, RadioError> {
        return currentTrack.eraseToAnyPublisher()
    }
    
    public func getCurrentStatus() -> AnyPublisher<RadioStatus, RadioError> {
        return status.eraseToAnyPublisher()
    }
    
    public func getSongQueue() -> AnyPublisher<[Track], RadioError> {
        return queue.eraseToAnyPublisher()
    }
    
    public func getLastPlayed() -> AnyPublisher<[Track], RadioError> {
        return lastPlayed.eraseToAnyPublisher()
    }
    
    public func getCurrentDJ() -> AnyPublisher<RadioDJ, RadioError> {
        return currentDJ.eraseToAnyPublisher()
    }
    
}


extension RadioGatewayImp {
    private func fetchFromAPI() {
        let timer = Timer.publish(every: 20.0, on: .current, in: .common)
            .autoconnect()
            .eraseToAnyPublisher()
        
        let now = Just(Date())
            
        now
            .merge(with: timer)
            .flatMap{ [unowned self] _ in
                return self.network
                    .execute(request: RadioMainAPI())
                    .catch{ err in
                        return Empty<RadioMainAPIResponseModel,Never>()
                }
                
        }
        .tryMap(self.mapper.map(from:))
        .sink(receiveCompletion: { evt in
            print(evt)
            
        },
              receiveValue: { [unowned self] model in
                self.manageNewAPI(result: model)
        }).store(in: &apiDisposeBag)
    }
    
    private func manageNewAPI(result: RadioDetailedModel){
        self.currentDJ.send(result.dj)
        self.currentTrack.send(result.currentTrack)
        self.status.send(result.status)
        self.queue.send(result.queue)
        self.lastPlayed.send(result.lastPlayed)
    }
}
