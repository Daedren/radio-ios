import Foundation
import Radio_domain
import Radio_cross
import Combine
import Intents

class SearchIntentHandler: NSObject, SearchIntentHandling {
    
    
    let searchUseCase: SearchForTermUseCase
    var queueDisposeBag = Set<AnyCancellable>()
    
    internal init(searchUseCase: SearchForTermUseCase,
                  queueDisposeBag: Set<AnyCancellable> = Set<AnyCancellable>()) {
        self.searchUseCase = searchUseCase
        self.queueDisposeBag = queueDisposeBag
    }
    
    
    func confirm(intent: SearchIntent, completion: @escaping (SearchIntentResponse) -> Void) {
        completion(SearchIntentResponse(code: .ready, userActivity: nil))
        
    }
    
    func resolveQuery(for intent: SearchIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let query = intent.query, !query.isEmpty {
            completion(.success(with: query))
        } else {
            completion(.needsValue())
        }
    }
    
    
    func handle(intent: SearchIntent, completion: @escaping (SearchIntentResponse) -> Void) {
        if let query = intent.query {
            fetchResultForQuery(query: query)
                .sink(receiveCompletion: { event in
                    switch event {
                    case .failure(_):
                        completion(.init(code: .failure, userActivity: nil))
                    default:
                        break
                    }
                },
                receiveValue: { tracks in
                    completion(SearchIntentResponse.success(tracks: tracks))
                })
                .store(in: &queueDisposeBag)
            
        } else {
            completion(SearchIntentResponse.success(tracks: []))
        }
    }
    
    
    func fetchResultForQuery(query: String) -> AnyPublisher<[IntentTrack],RadioError> {
        return searchUseCase
            .execute(query)
            .first()
            .handleEvents(receiveSubscription: { _ in
                //            completion(SearchIntentResponse(code: .inProgress, userActivity: nil))
            })
            .first()
            .map{ tracks -> [IntentTrack] in
                tracks.map{ track -> IntentTrack in
                    let intTrack = IntentTrack(identifier: track.title, display: "\(track.artist) - \(track.title)")
                    intTrack.artist = track.artist
                    intTrack.title = track.title
                    return intTrack
                }
            }
            .eraseToAnyPublisher()
    }
}

extension SearchIntentHandler: INSearchForMediaIntentHandling {
    func handle(intent: INSearchForMediaIntent, completion: @escaping (INSearchForMediaIntentResponse) -> Void) {
//        updateUseCase.execute(())
        
        guard let mediaItems = intent.mediaItems, !mediaItems.isEmpty else {
            completion(.init(code: .failure, userActivity: nil))
            return
        }
        
        // Combine flatMap is iOS 14.0 only LOOL
        //            let publishers = Just(mediaItems)
        //                .map{ $0.publisher }
        //                .switchToLatest()
        //                .map { item in
        //                    return "\(item.artist ?? "") \(item.title ?? "")"
        //                }
        //                .flatMap{ [unowned self] query in
        //                    return self.fetchResultForQuery(query: query)
        //                }
        //                .eraseToAnyPublisher()
        
        var allResults = [INMediaItem]()
        let group = DispatchGroup()
        for item in mediaItems {
            group.enter()
            let query = "\(item.artist ?? "") \(item.title ?? "")"
            self.fetchResultForQuery(query: query)
                .map{ searchedTracks -> [INMediaItem] in
                    return searchedTracks.map{ searchedTrack -> INMediaItem in
                        let fullTitle = "\(searchedTrack.title ?? "") \(searchedTrack.artist ?? "")"
                        return INMediaItem(identifier: fullTitle,
                                    title: fullTitle,
                                    type: .music,
                                    artwork: nil)
                    }
                    
                }
                .sink(receiveCompletion: { event in
                    switch event {
                    case .failure(_):
                        completion(.init(code: .failure, userActivity: nil))
                    default:
                        break
                    }
                },
                receiveValue: { tracks in
                    allResults.append(contentsOf: tracks)
                })
                .store(in: &queueDisposeBag)
            group.leave()
        }
        group.notify(queue: .global(), execute: {
            let result = INSearchForMediaIntentResponse(code: .success, userActivity: nil)
            result.mediaItems = allResults
            completion(result)
        })
    }

        
        
        func confirm(intent: INSearchForMediaIntent, completion: @escaping (INSearchForMediaIntentResponse) -> Void) {
            completion(INSearchForMediaIntentResponse(code: .ready, userActivity: nil))
            
        }
        
        func resolveMediaItems(for intent: INSearchForMediaIntent, with completion: @escaping ([INSearchForMediaMediaItemResolutionResult]) -> Void) {
            let results = intent.mediaItems?.map{ item -> INSearchForMediaMediaItemResolutionResult in
                return INSearchForMediaMediaItemResolutionResult(mediaItemResolutionResult: .success(with: item))
            }
            
            completion(results ?? [])
        }
        
        
    }
