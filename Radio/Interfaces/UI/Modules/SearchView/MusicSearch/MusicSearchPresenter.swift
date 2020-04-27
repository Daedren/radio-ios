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
    @Published var acceptingRequests = false
    
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
            return value.map{ SearchedTrackViewModel(from: $0)}
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
    
    func createViewModels(from requests: [SearchedTrack]) {
        
    }

    func request(_ index: Int) {
        let song = self.searchedTracks[index]
        var viewModel = self.returnedValues[index]
        viewModel.state = .loading
        DispatchQueue.main.async {
            self.returnedValues[index] = viewModel
        }
        if song.requestable ?? false {
            self.requestInteractor?.execute(song.id)
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { result in
                    print(song.title)
                    if result {
                        viewModel.state = .notRequestable
                        print("Success")
                    }
                    else {
                        viewModel.state = .requestable
                        print("Failure")
                    }
                    DispatchQueue.main.async {
                        self.returnedValues[index] = viewModel
                    }
                })
            .store(in: &requestDisposeBag)
        }
        else {
            var viewModel = self.returnedValues[index]
            viewModel.state = .notRequestable
            DispatchQueue.main.async {
                self.returnedValues[index] = viewModel
            }
        }
    }
    
}
