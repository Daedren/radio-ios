import Foundation
import Radio_domain
import Radio_interfaces
import Radio_cross
import Combine
import SwiftUI

class MusicSearchPresenterImp: SearchPresenterImp {
    
    var searchInteractor: SearchForTermUseCase?
    override var extraActionPublishers: [AnyPublisher<SearchListState.Mutation, Never>] {
        get {
            return [getStatus()]
        }
    }

    init(searchInteractor: SearchForTermUseCase?,
         requestInteractor: RequestSongUseCase?,
         statusInteractor: GetCurrentStatusUseCase?,
         cooldownInteractor: CanRequestSongUseCase?) {
        self.searchInteractor = searchInteractor
        
        super.init(requestInteractor: requestInteractor,
                   statusInteractor: statusInteractor,
                   cooldownInteractor: cooldownInteractor)
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
            .receive(on: DispatchQueue.global(qos: .default))
            .eraseToAnyPublisher()
    }
}
