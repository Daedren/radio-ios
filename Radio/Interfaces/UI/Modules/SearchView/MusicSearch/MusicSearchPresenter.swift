import Foundation
import Radio_Domain
import Combine
import SwiftUI

//class SearchPresenterPreviewer: SearchPresenter {
//    @Published var searchedText: String = ""
//    @Published var returnedValues: [SearchedTrackViewModel] = []
//}

class MusicSearchPresenterImp: SearchPresenter {
    @Published var searchedText: String = "" {
        didSet {
            self.searchEngine.send(self.searchedText)
        }
    }
    @Published var returnedValues: [SearchedTrackViewModel] = []
    @Published var randomTrack: RandomTrackViewModel
    @Published var acceptingRequests = false
    @Published var titleBarText = "Search"
    
    var searchDisposeBag = Set<AnyCancellable>()
    var requestDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: SearchForTermInteractor?
    var requestInteractor: RequestSongInteractor?
    var statusInteractor: GetCurrentStatusInteractor?
    
    var searchedTracks = [SearchedTrack]()
    
    init(searchInteractor: SearchForTermInteractor, requestInteractor: RequestSongInteractor, statusInteractor: GetCurrentStatusInteractor) {
        self.searchInteractor = searchInteractor
        self.requestInteractor = requestInteractor
        self.statusInteractor = statusInteractor
        
        self.randomTrack = RandomTrackViewModel(id: 0, state: .requestable)
        
        self.searchEngine
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter{ $0 != ""}
            .flatMap{ value -> AnyPublisher<[SearchedTrack],RadioError> in
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
        .print()
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
    
    func createViewModels(from requests: [SearchedTrack]) {
        
    }
    
    func requestRandom(track: RandomTrackViewModel) {
        if let song = self.searchedTracks.randomElement() {
            self.requestSong(viewModel: track,
                             track: song,
                             stateChange: { [weak self] newState in
                                var viewModel = track
                                viewModel.state = newState
                                DispatchQueue.main.async {
                                    self?.randomTrack = viewModel
                                }
            })
        }
        
    }
    
    func request(track: SearchedTrackViewModel) {
        let song = self.searchedTracks[track.id]
        
        self.requestSong(viewModel: track,
                         track: song,
                         stateChange: { [weak self] newState in
                            var viewModel = track
                            viewModel.state = newState
                            DispatchQueue.main.async {
                                self?.returnedValues[track.id] = viewModel
                            }
        })
    }
    
    func requestSong(viewModel: RequestButtonViewModel, track: SearchedTrack, stateChange: @escaping ((SearchTrackState)->Void)) {
        stateChange(.loading)
        if track.requestable ?? false {
            self.requestInteractor?.execute(track.id)
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { result in
                    if result {
                        stateChange(.notRequestable)
                    }
                    else {
                        stateChange(.requestable)
                    }
                })
                .store(in: &requestDisposeBag)
        }
        else {
            stateChange(.notRequestable)
        }
    }
    
}
