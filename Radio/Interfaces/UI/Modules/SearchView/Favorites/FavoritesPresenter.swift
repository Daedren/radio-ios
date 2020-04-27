import Foundation
import Combine
import Radio_Domain

class FavoritesPresenterImp: SearchPresenter {
    @Published var searchedText: String = "" {
        didSet {
            self.searchEngine.send(self.searchedText)
        }
    }
    @Published var returnedValues: [SearchedTrackViewModel] = []
    @Published var randomTrack: RandomTrackViewModel
    @Published var acceptingRequests = false
    @Published var titleBarText = "Favorites"
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: GetFavoritesInteractor?
    var requestInteractor: RequestSongInteractor?
    var statusInteractor: GetCurrentStatusInteractor?
    
    var searchedTracks = [FavoriteTrack]()
    
    init(searchInteractor: GetFavoritesInteractor, requestInteractor: RequestSongInteractor, statusInteractor: GetCurrentStatusInteractor) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        
        self.randomTrack = RandomTrackViewModel(id: 0, state: .requestable)
        
        self.searchEngine
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter{ $0 != ""}
            .flatMap{ value -> AnyPublisher<[FavoriteTrack],RadioError> in
                return searchInteractor.execute(value)
        }
        .handleEvents(receiveOutput: { [weak self] in
            self?.searchedTracks = $0
        })
            .map{ value in
                var viewModels = [SearchedTrackViewModel]()
                for i in 0..<value.count {
                    viewModels.append(SearchedTrackViewModel(from: value[i], with: i))
                }
                return viewModels
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.returnedValues = value
        })
            .store(in: &searchDisposeBag)
        
        statusInteractor.execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { status in
                    self.acceptingRequests = status.acceptingRequests
            })
            .store(in: &searchDisposeBag)
    }
    
    func createViewModels(from requests: [FavoriteTrack]) {
        
    }
    
    func requestRandom(track: RandomTrackViewModel) {

    }
    
    func request(track: SearchedTrackViewModel) {
        
    }
    
}
