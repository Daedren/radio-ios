import Foundation
import Radio_domain
import Radio_cross
import Combine
import Intents

extension RandomFaveIntentResponseCode: Error {

}

class RandomFaveIntentHandler: NSObject, RandomFaveIntentHandling {
    
    let getUsernameUseCase: GetLastFavoriteUserUseCase?
    let requestUseCase: RequestSongUseCase?
    var searchUseCase: GetFavoritesInteractor?
    
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
        var code: RandomFaveIntentResponseCode = .ready
        if getUsernameUseCase == nil || searchUseCase == nil {
            code = .failure
        }
        completion(RandomFaveIntentResponse(code: code, userActivity: nil))
    }
    
    func handle(intent: RandomFaveIntent, completion: @escaping (RandomFaveIntentResponse) -> Void) {
        guard let getUsernameUseCase = getUsernameUseCase, searchUseCase != nil else {
            completion(RandomFaveIntentResponse(code: .failure, userActivity: nil))
            return
        }

        getUsernameUseCase.execute()
            .flatMap{ username -> AnyPublisher<String, RandomFaveIntentResponseCode> in
                if username.isEmpty {
                    return Fail(outputType: String.self, failure: .noUsernameFailure)
                        .eraseToAnyPublisher()
                }
                return Just(username)
                    .setFailureType(to: RandomFaveIntentResponseCode.self)
                    .eraseToAnyPublisher()
            }
            .flatMap { username -> AnyPublisher<FavoriteTrack, RandomFaveIntentResponseCode> in
                self.fetchResultForQuery(query: username)
                    .mapError{ _ in return RandomFaveIntentResponseCode.failure }
                .eraseToAnyPublisher()
            }
            .flatMap{ track -> AnyPublisher<(Bool, FavoriteTrack), RandomFaveIntentResponseCode> in
                return self.executeTrack(track: track)
                    .map{ requestResult in
                        return (requestResult, track)
                    }
                    .mapError{ err in
                        switch err {
                        case .cannotRequestUnknownTime, .cannotRequestDueToTime:
                            return RandomFaveIntentResponseCode.cooldownFailure
                        case .notAcceptingRequests:
                            return RandomFaveIntentResponseCode.notAcceptingRequests
                        default:
                            return RandomFaveIntentResponseCode.failure

                        }
                    }
                    .eraseToAnyPublisher()
            }
            .sink(receiveCompletion: { event in
                switch event {
                case .failure(let code):
                    completion(.init(code: code, userActivity: nil))
                default:
                    break
                }
            },
              receiveValue: { result in
                let (result, track) = result

                if result {
                    let trackName = "\(track.artist) - \(track.title)"
                    completion(RandomFaveIntentResponse.success(track: trackName))
                } else {
                    completion(RandomFaveIntentResponse(code: .failure, userActivity: nil))
                }
            })
            .store(in: &disposeBag)


        

    }
    
    func fetchResultForQuery(query: String) -> AnyPublisher<FavoriteTrack, RadioError> {
        return searchUseCase!
            .execute(query)
            .first()
            .compactMap{ favorites in
                favorites
                    .filter{ ($0.requestable ?? false) && ($0.id != nil) }
                    .randomElement()
            }
            .eraseToAnyPublisher()
    }
    
    func executeTrack(track: FavoriteTrack) -> AnyPublisher<Bool, RequestSongUseCaseError> {
        guard let requestUseCase = requestUseCase else {
            return Fail(error: RequestSongUseCaseError.genericError(.unknown))
                .eraseToAnyPublisher()
        }
        
        return Just(track)
            .compactMap { $0.id }
            .flatMap{ trackId in
                return requestUseCase.execute(trackId)
            }
            .eraseToAnyPublisher()
        
    }
    
}
