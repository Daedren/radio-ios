import Foundation
import Combine
import Radio_domain
import Radio_interfaces
import Radio_cross


class FavoritesPresenterImp: SearchPresenterImp {

    var searchInteractor: GetFavoritesInteractor?
    var lastUsernameInteractor: GetLastFavoriteUserUseCase?

    init(searchInteractor: GetFavoritesInteractor,
         requestInteractor: RequestSongUseCase,
         statusInteractor: GetCurrentStatusUseCase,
         cooldownInteractor: CanRequestSongUseCase,
         lastUsername: GetLastFavoriteUserUseCase) {
        self.searchInteractor = searchInteractor
        self.lastUsernameInteractor = lastUsername
        super.init(requestInteractor: requestInteractor,
                   statusInteractor: statusInteractor,
                   cooldownInteractor: cooldownInteractor)
    }
    
    override func start(actions: AnyPublisher<SearchListAction, Never>) {
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
    
    // MARK: ACTIONS

    override func search(text: String) -> AnyPublisher<SearchListState.Mutation, Never> {
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
}
