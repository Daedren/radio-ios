import Foundation
import Combine
import Radio_Domain


class FavoritesPresenterImp: SearchPresenter {

    @Published var state: SearchListState
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: GetFavoritesInteractor?
    var requestInteractor: RequestSongInteractor?
    var statusInteractor: GetCurrentStatusInteractor?
    
    var searchedTracks = [FavoriteTrack]()
    
    init(searchInteractor: GetFavoritesInteractor,
         requestInteractor: RequestSongInteractor,
         statusInteractor: GetCurrentStatusInteractor) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        
        self.state = SearchListState.initial
    }
    
    func send(_ action: SearchListAction) {
        
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
            return self.request(track: self.searchedTracks[indexPath])
        case let .search(searchedText):
            return self.search(text: searchedText)
        }
        
    }
    
    
    func createViewModels(from requests: [FavoriteTrack]) -> [SearchedTrackViewModel] {
        var viewModels = [SearchedTrackViewModel]()
        for i in 0..<requests.count {
            viewModels.append(SearchedTrackViewModel(from: requests[i], with: i))
        }
        return viewModels
    }
    
    // MARK: ACTIONS
    
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
