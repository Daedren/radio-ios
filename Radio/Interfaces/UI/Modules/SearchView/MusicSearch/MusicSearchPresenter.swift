import Foundation
import Radio_domain
import Combine
import SwiftUI

//class SearchPresenterPreviewer: SearchPresenter {
//    @Published var searchedText: String = ""
//    @Published var returnedValues: [SearchedTrackViewModel] = []
//}

class MusicSearchPresenterImp: SearchPresenter {
    
    @Published var state: SearchListState
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: SearchForTermInteractor?
    var requestInteractor: RequestSongInteractor?
    var statusInteractor: GetCurrentStatusInteractor?
    var cooldownInteractor: CanRequestSongInteractor?
    
    var searchedTracks = [SearchedTrack]()
    var searchedTerm = ""
    
    init(searchInteractor: SearchForTermInteractor,
         requestInteractor: RequestSongInteractor,
         statusInteractor: GetCurrentStatusInteractor,
         cooldownInteractor: CanRequestSongInteractor) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        self.cooldownInteractor = cooldownInteractor
        
        self.state = SearchListState.initial
    }

    func start(actions: AnyPublisher<SearchListAction, Never>) {
        let actions = actions
            .flatMap(handleAction)
        
        let outside = getStatus()
        
        actions.merge(with: outside)
            .scan(SearchListState.initial, SearchListState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { newState in
                self.state = newState
            })
            .store(in: &searchDisposeBag)
    }
    
    private func handleAction(_ action: SearchListAction) -> AnyPublisher<SearchListState.Mutation, Never> {
        
        switch action {
        case .chooseRandom:
            return self.requestRandom()
        case let .choose(indexPath):
            return self.request(index: indexPath)
                .append(self.getRequestStatus())
                .eraseToAnyPublisher()
        case let .search(searchedText):
            self.searchedTerm = searchedText
            return self.search(text: searchedText)
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
                    let formattedDate = date.offsetFrom(date: Date())
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
        let index = Int.random(in: 0 ... self.searchedTracks.count-1)
        let song = self.searchedTracks[index]
        
        return self.requestSong(track: song)
            .prepend(.loading(index))
        .eraseToAnyPublisher()
    }
    
    func request(index: Int) -> AnyPublisher<SearchListState.Mutation, Never> {
        let song = self.searchedTracks[index]
        
        return self.requestSong(track: song)
            .prepend(.loading(index))
        .eraseToAnyPublisher()
    }
    
    func requestSong(track: SearchedTrack) -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let requestInteractor = self.requestInteractor else { fatalError("Missing DI") }
        
        if track.requestable ?? false {
            return requestInteractor
                .execute(track.id)
                .flatMap{ result -> AnyPublisher<SearchListState.Mutation,RequestSongUseCaseError> in
                    if result {
                        // refresh search when done.
                        return self.search(text: self.searchedTerm)
                            .mapError{ _ -> RequestSongUseCaseError in return .genericError(.unknown) }
                            .eraseToAnyPublisher()
                    } else {
                        return Empty().eraseToAnyPublisher()
                    }
            }
            .catch{ err in
                return Just(SearchListState.Mutation.error(err.localizedDescription))
            }
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
        } else {
            return Empty().eraseToAnyPublisher()
        }
    }
}
