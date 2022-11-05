import Foundation
import Radio_domain
import Radio_interfaces
import Radio_cross
import Combine
import SwiftUI

//class SearchPresenterPreviewer: SearchPresenter {
//    @Published var searchedText: String = ""
//    @Published var returnedValues: [SearchedTrackViewModel] = []
//}

class MusicSearchPresenterImp: SearchPresenter, Logging {
    
    @Published var state: SearchListState
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: SearchForTermUseCase?
    var requestInteractor: RequestSongUseCase?
    var statusInteractor: GetCurrentStatusUseCase?
    var cooldownInteractor: CanRequestSongUseCase?
    
    var searchedTracks = [SearchedTrack]()
    var searchedTerm = ""
    
    init(searchInteractor: SearchForTermUseCase?,
         requestInteractor: RequestSongUseCase?,
         statusInteractor: GetCurrentStatusUseCase?,
         cooldownInteractor: CanRequestSongUseCase?) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        self.cooldownInteractor = cooldownInteractor
        
        self.state = SearchListState.initial
    }
    
    func start(actions: AnyPublisher<SearchListAction, Never>) {
        let actions = actions
            .handleEvents(receiveOutput: { [weak self] output in
                self?.log(message: "action: "+String(describing: output))
            })
            .flatMap(handleAction)
        let outside = getStatus()
        
        actions.merge(with: outside)
            .handleEvents(receiveOutput: { [weak self] newVal in
                self?.log(message: "mutation: \(newVal)", logLevel: .verbose)
            })
            .scan(SearchListState.initial, SearchListState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newState in
                self.state = newState
            })
            .store(in: &searchDisposeBag)
    }
    
    func handleAction(_ action: SearchListAction) -> AnyPublisher<SearchListState.Mutation, Never> {
        
        switch action {
        case .chooseRandom:
            return self.requestRandom()
        case let .choose(indexPath):
            return self.request(index: indexPath)
                .flatMap { [weak self] req -> AnyPublisher<SearchListState.Mutation, Never> in
                    guard let `self` = self else { return Empty<SearchListState.Mutation, Never>().eraseToAnyPublisher() }
                    return Just(req)
                        .append(self.getRequestStatus())
                        .eraseToAnyPublisher()
                }
//                .append(self.getRequestStatus())
                .eraseToAnyPublisher()
        case let .search(searchedText):
            self.searchedTerm = searchedText
            return self.search(text: searchedText)
                .prepend(Just(SearchListState.Mutation.searchTermChanged(searchedText)))
                .eraseToAnyPublisher()
        case .viewDidAppear:
            return self.getRequestStatus()
        }
        
    }
    
    func createViewModels(from requests: [SearchedTrack]) -> [SearchedTrackViewModel] {
        var viewModels = [SearchedTrackViewModel]()
        for i in 0..<requests.count {
            viewModels.append(SearchedTrackViewModel(from: requests[i], with: i))
        }
        return viewModels
    }
    
    // MARK: ACTIONS
    
    func getRequestStatus() -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let cooldownInteractor = self.cooldownInteractor else { fatalError() }
        return cooldownInteractor
            .execute()
            .map{ result -> SearchListState.Mutation in
                if result.canRequest {
                    return .canRequest
                } else if let date = result.timeUntilCanRequest {
                    let formattedDate = date.timeToView()
                    return .canRequestAt(formattedDate)
                } else {
                    return .cannotRequest
                }
                
            }
            .eraseToAnyPublisher()
    }
    
    func getStatus() -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let statusInteractor = self.statusInteractor else { fatalError() }
        return statusInteractor
            .execute()
            .map { status in
                return SearchListState.Mutation.acceptingRequests(status.acceptingRequests)
            }
            .catch{ err in
                return Just(SearchListState.Mutation.error(err.localizedDescription))
            }
            .eraseToAnyPublisher()
    }
    
    func search(text: String) -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let searchInteractor = self.searchInteractor else { return Just<SearchListState.Mutation>(.error("")).eraseToAnyPublisher() }
        return searchInteractor
            .execute(text)
            .handleEvents(receiveOutput: { [weak self] newTracks in
                self?.searchedTracks = newTracks
            })
            .map{ [unowned self] newTracks -> SearchListState.Mutation in
                let cellModels = self.createViewModels(from: newTracks)
                return SearchListState.Mutation.searchedTracks(cellModels)
            }
            .catch{ err in
                return Just(SearchListState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
    
    func requestRandom() -> AnyPublisher<SearchListState.Mutation, Never> {
        let requestableTracks = self.searchedTracks.filter{ $0.requestable ?? false }
        let index = Int.random(in: 0 ... requestableTracks.count-1)
        let song = requestableTracks[index]
        
        return self.requestSong(index: index, track: song)
            .prepend(.loading(index))
            .eraseToAnyPublisher()
    }
    
    func request(index: Int) -> AnyPublisher<SearchListState.Mutation, Never> {
        let song = self.searchedTracks[index]
        
        return self.requestSong(index: index, track: song)
            .prepend(.loading(index))
            .eraseToAnyPublisher()
    }
    
    func requestSong(index: Int, track: SearchedTrack) -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let requestInteractor = self.requestInteractor else { fatalError("Missing DI") }
        
        if track.requestable ?? false {
            return requestInteractor
                .execute(track.id)
                .map{ result -> SearchListState.Mutation in
                    if !result {
                        return SearchListState.Mutation.songRequestable(index)
                    } else {
                        return SearchListState.Mutation.notRequestable(index)
                    }
                }
                .catch { err in
                    return Just(SearchListState.Mutation.error(err.localizedDescription))
                }
                .receive(on: DispatchQueue.global(qos: .default))
                .eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
