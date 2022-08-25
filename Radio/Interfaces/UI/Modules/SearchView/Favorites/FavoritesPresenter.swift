import Foundation
import Combine
import Radio_domain
import Radio_interfaces
import Radio_cross


class FavoritesPresenterImp: SearchPresenter, Logging {

    @Published var state: SearchListState
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: GetFavoritesInteractor?
    var requestInteractor: RequestSongUseCase?
    var statusInteractor: GetCurrentStatusUseCase?
    var cooldownInteractor: CanRequestSongUseCase?
    var lastUsernameInteractor: GetLastFavoriteUserUseCase?

    
    var searchedTracks = [FavoriteTrack]()
    
    init(searchInteractor: GetFavoritesInteractor,
         requestInteractor: RequestSongUseCase,
         statusInteractor: GetCurrentStatusUseCase,
         cooldownInteractor: CanRequestSongUseCase,
         lastUsername: GetLastFavoriteUserUseCase) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        self.cooldownInteractor = cooldownInteractor
        self.lastUsernameInteractor = lastUsername
        
        self.state = SearchListState.initial
    }
    
    func start(actions: AnyPublisher<SearchListAction, Never>) {
        let actions = actions
            .flatMap(handleAction)
        
        let outside = getStatus()
        let username = getLastFavoriteUsername()
        
        actions.merge(with: outside, username)
            .handleEvents(receiveOutput: { [weak self] newVal in
                self?.log(message: "\(newVal)", logLevel: .verbose)
            })
            .scan(SearchListState.initial, SearchListState.reduce(state:mutation:))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] newState in
                self?.state = newState
            })
            .store(in: &searchDisposeBag)
    }
    
    private func handleAction(_ action: SearchListAction) -> AnyPublisher<SearchListState.Mutation, Never> {
        
        switch action {
        case .chooseRandom:
            return self.requestRandom()
        case let .choose(indexPath):
            return self.request(track: self.searchedTracks[indexPath])
        case let .search(searchedText):
            return self.search(text: searchedText)
                .prepend(SearchListState.Mutation.searchTermChanged(searchedText))
                .eraseToAnyPublisher()
        case .viewDidAppear:
            return self.getRequestStatus()
        }
        
    }
    
    
    func createViewModels(from requests: [FavoriteTrack]) -> [SearchedTrackViewModel] {
        var viewModels = [SearchedTrackViewModel]()
        for i in 0..<requests.count {
            viewModels.append(SearchedTrackViewModel(from: requests[i], with: i))
        }
        return viewModels
    }
    
    // MARK: CALLS TO DOMAIN
    
    func getLastFavoriteUsername() -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let lastUsernameInteractor = self.lastUsernameInteractor else { fatalError() }
        
        return lastUsernameInteractor
            .execute()
            .flatMap{ [unowned self] lastUsername -> AnyPublisher<SearchListState.Mutation, Never> in
                // Change the textfield
                var mutation = Just(SearchListState.Mutation.searchTermChanged(lastUsername))
                    .eraseToAnyPublisher()
                
                // Perform the search if needed
                if !lastUsername.isEmpty {
                    mutation = mutation.append(self.search(text: lastUsername))
                        .eraseToAnyPublisher()
                }
                return mutation.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    
    
    func getRequestStatus() -> AnyPublisher<SearchListState.Mutation, Never> {
        guard let cooldownInteractor = self.cooldownInteractor else { fatalError() }
        return cooldownInteractor
            .execute()
            .map{ result -> SearchListState.Mutation in
                if result.canRequest {
                    return .canRequest
                } else if let date = result.timeUntilCanRequest {
                    let formattedDate = date.dateToView()
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
    
    // MARK: ACTIONS

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
        .eraseToAnyPublisher()
    }
    
    func requestRandom() -> AnyPublisher<SearchListState.Mutation, Never> {
        return Empty().eraseToAnyPublisher()
    }
    
    func request(track: FavoriteTrack) -> AnyPublisher<SearchListState.Mutation, Never> {
        return Empty().eraseToAnyPublisher()
    }
    
}
