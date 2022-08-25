import Foundation
import Radio_domain
import Radio_cross
import Combine
import Intents

class RandomFaveIntentHandler: NSObject, RandomFaveIntentHandling {
    
    let getUsernameUseCase: GetLastFavoriteUserUseCase?
    let requestUseCase: RequestSongUseCase?
    var searchUseCase: GetFavoritesInteractor?
    
    var storedUsername: String = ""
    var disposeBag = Set<AnyCancellable>()
    
    internal init(
        getUsernameUseCase: GetLastFavoriteUserUseCase? = nil,
        requestUseCase: RequestSongUseCase? = nil,
        searchUseCase: GetFavoritesInteractor? = nil
    ) {
        self.getUsernameUseCase = getUsernameUseCase
        self.requestUseCase = requestUseCase
        self.searchUseCase = searchUseCase
    }
    
    
    func confirm(intent: RandomFaveIntent, completion: @escaping (RandomFaveIntentResponse) -> Void) {
        guard let getUsernameUseCase = getUsernameUseCase, searchUseCase != nil else {
            completion(RandomFaveIntentResponse(code: .failure, userActivity: nil))
            return
        }
        
        getUsernameUseCase.execute().sink(receiveValue: { [weak self] username in
            if username.isEmpty {
                completion(RandomFaveIntentResponse(code: .noUsernameFailure, userActivity: nil))
            } else {
                completion(RandomFaveIntentResponse(code: .ready, userActivity: nil))
            }
            
            self?.storedUsername = username
        })
        .store(in: &disposeBag)
        
    }
    
    func handle(intent: RandomFaveIntent, completion: @escaping (RandomFaveIntentResponse) -> Void) {
        
        let trackIdFlow = fetchResultForQuery(query: self.storedUsername)
            .compactMap{ favorites in
                favorites
                    .filter{ ($0.requestable ?? false) && ($0.id != nil) }
                    .randomElement()
                    .map{ $0.id }
            }
            .eraseToAnyPublisher()
        
        let songRequestFlow = executeTrack(publisher: trackIdFlow)
        
        songRequestFlow
            .sink(receiveCompletion: { event in
                switch event {
                case .failure(_):
                    completion(.init(code: .failure, userActivity: nil))
                default:
                    break
                }
            },
                  receiveValue: { result in
                completion(RandomFaveIntentResponse(code: result ? .success : .failure, userActivity: nil))
            })
            .store(in: &disposeBag)
        
    }
    
    func fetchResultForQuery(query: String) -> AnyPublisher<[FavoriteTrack],RadioError> {
        return searchUseCase!
            .execute(query)
            .first()
            .handleEvents(receiveSubscription: { _ in
                //            completion(SearchIntentResponse(code: .inProgress, userActivity: nil))
            })
            .first()
            .eraseToAnyPublisher()
    }
    
    func executeTrack(publisher: AnyPublisher<Int?, RadioError>) -> AnyPublisher<Bool, RequestSongUseCaseError> {
        guard let requestUseCase = requestUseCase else {
            return Fail(error: RequestSongUseCaseError.genericError(.unknown))
                .eraseToAnyPublisher()
        }
        
        return publisher
            .compactMap{ $0 }
            .mapError{ RequestSongUseCaseError.genericError($0)}
            .flatMap{ trackId in
                return requestUseCase.execute(trackId)
            }
            .eraseToAnyPublisher()
        
    }
    
}
