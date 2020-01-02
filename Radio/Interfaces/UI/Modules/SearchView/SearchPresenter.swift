import Foundation
import Radio_Domain
import Combine
import SwiftUI

//protocol SearchPresenter: ObservableObject {
//    var searchedText: Binding<String> { get }
//    var returnedValues: [SearchedTrackViewModel] { get }
//}

//class SearchPresenterPreviewer: SearchPresenter {
//    @Binding var searchedText: String = ""
//    @Published var returnedValues: [SearchedTrackViewModel] = []
//}

class SearchPresenterImp: ObservableObject {
    @Published var searchedText: String = "" {
        didSet {
            self.searchEngine.send(self.searchedText)
        }
    }
    @Published var returnedValues: [SearchedTrackViewModel] = []
    
    var searchDisposeBag = Set<AnyCancellable>()
    var searchEngine = PassthroughSubject<String, RadioError>()
    
    var searchInteractor: SearchForTermInteractor?
    
    init(searchInteractor: SearchForTermInteractor) {
        self.searchInteractor = searchInteractor
        
        
        self.searchEngine
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .removeDuplicates()
            .filter{ $0 != ""}
            .flatMap{ value -> AnyPublisher<[SearchedTrack],RadioError> in
                return searchInteractor.execute(value)
        }
        .map{ value in
            return value.map{ SearchedTrackViewModel(from: $0)}
        }
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in
            
        }, receiveValue: { [weak self] value in
            self?.returnedValues = value
        })
        .store(in: &searchDisposeBag)
    }
    
}
