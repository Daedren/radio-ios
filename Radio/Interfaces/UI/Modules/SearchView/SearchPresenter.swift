import Foundation
import Radio_Domain
import Combine
import SwiftUI

protocol SearchPresenter: ObservableObject {
    var searchedText: String { get }
    var returnedValues: [SearchedTrackViewModel] { get }
    var acceptingRequests: Bool { get }
    func request(song: Int)
}

//class SearchPresenterPreviewer: SearchPresenter {
//    @Published var searchedText: String = ""
//    @Published var returnedValues: [SearchedTrackViewModel] = []
//}

class SearchPresenterImp: ObservableObject {
    @Published var searchedText: String = "" {
        didSet {
            self.searchEngine.send(self.searchedText)
        }
    }
    @Published var returnedValues: EnumeratedSequence<[SearchedTrackViewModel]> = [SearchedTrackViewModel]().enumerated()
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
            self?.returnedValues = value.enumerated()
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
    
    func request(song: Int) {
        let song = self.searchedTracks[song]
        if song.requestable ?? false {
            self.requestInteractor?.execute(song.id)
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { result in
                    print(song.title)
                    if result {
                        print("Success")
                    }
                    else {
                        print("Failure")
                    }
                })
            .store(in: &requestDisposeBag)
        }
    }
    
}
