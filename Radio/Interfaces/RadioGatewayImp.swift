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
    
    func getCurrentTrack() -> AnyPublisher<Track, RadioError> {
        return currentTrack.eraseToAnyPublisher()
    }
    
    func getCurrentStatus() -> AnyPublisher<RadioStatus, RadioError> {
        return status.eraseToAnyPublisher()
    }
    
    func getSongQueue() -> AnyPublisher<[Track], RadioError> {
        return queue.eraseToAnyPublisher()
    }
    
    func getLastPlayed() -> AnyPublisher<[Track], RadioError> {
        return lastPlayed.eraseToAnyPublisher()
    }
    
    func getCurrentDJ() -> AnyPublisher<RadioDJ, RadioError> {
        return currentDJ.eraseToAnyPublisher()
    }
    
}


extension RadioGatewayImp {
    private func fetchFromAPI() {
        Timer.publish(every: 60.0, on: .current, in: .default)
            .autoconnect()
            .flatMap{ [unowned self] _ in
                return self.network
                    .execute(request: RadioMainAPI())
                    .catch{ _ in return Empty<RadioMainAPIResponseModel,Never>()}
        }
        .tryMap(self.mapper.map(from:))
        .sink(receiveCompletion: { _ in
            
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
