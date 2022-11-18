import Foundation
import Combine
import Radio_interfaces

class SearchPresenterPreviewer: SearchPresenter {
    @Published var state = SearchListState()
    
    init() {
        state.acceptingRequests = true
        state.canRequest = false
        state.loadingGeneral = false
        state.tracks = [SearchedTrackViewModel.stub(), SearchedTrackViewModel.stub(), SearchedTrackViewModel.stub()]
        state.tracks[1].state = .disabled
    }
    
    func start(actions: AnyPublisher<SearchListAction, Never>) {
        
    }
}

protocol SearchPresenter: ObservableObject {
    var state: SearchListState { get set }
    func start(actions: AnyPublisher<SearchListAction, Never>)
}


struct SearchListState: Equatable {
    var tracks: [SearchedTrackViewModel] = []
    var randomTrack = RandomTrackViewModel(state: .enabled)
    var acceptingRequests: Bool = false
    var error: String?
    var canRequest: Bool = false
    var canRequestAt: String?
    var loadingGeneral: Bool = true
    var searchTerm: String = ""
    
    static var initial = SearchListState()
    
    enum Mutation: Equatable {
        case searchedTracks([SearchedTrackViewModel])
        case acceptingRequests(Bool)
        case loading(Int)
        case notRequestable(Int)
        case songRequestable(Int)
        case loadingRandom
        //        case randomTrack(RandomTrackViewModel)
        case error(String)
        case canRequestAt(String)
        case canRequest
        case cannotRequest
        case searchTermChanged(String)
    }
    
    static func reduce(state: SearchListState, mutation: Mutation) -> SearchListState {
        var state = state
        
        
        switch mutation {
        case let .acceptingRequests(value):
            state.acceptingRequests = value
        case let .error(error):
            state.error = error
            state.tracks
                .indices
                .filter{ state.tracks[$0].state == .loading }
                .forEach{ state.tracks[$0].state = .enabled }
            
            if state.randomTrack.state == .loading {
                state.randomTrack.state = .enabled
            }
            case .loadingRandom:
            state.randomTrack.state = .loading
        case let .searchedTracks(models):
            state.error = nil
            state.tracks = models
        case let .loading(index):
            state.tracks[index].state = .loading
            state.loadingGeneral = true
        case let .notRequestable(index):
            state.tracks[index].state = .disabled
        case let .songRequestable(index):
            state.tracks[index].state = .enabled
        case let .canRequestAt(date):
            state.canRequestAt = date
            state.canRequest = false
            state.loadingGeneral = false
            state.randomTrack.state = .disabled
        case .cannotRequest:
            state.canRequestAt = nil
            state.canRequest = false
            state.randomTrack.state = .disabled
            state.loadingGeneral = false
        case .canRequest:
            state.canRequestAt = nil
            state.canRequest = true
            state.randomTrack.state = .enabled
            state.loadingGeneral = false
        case let .searchTermChanged(value):
            state.searchTerm = value
        }
        
        return state
    }
    
    static func == (lhs: SearchListState, rhs: SearchListState) -> Bool {
        lhs.tracks == rhs.tracks &&
            lhs.randomTrack == rhs.randomTrack &&
            lhs.acceptingRequests == rhs.acceptingRequests &&
            (lhs.error == nil && rhs.error == nil || lhs.error != nil && rhs.error != nil)
    }
}
