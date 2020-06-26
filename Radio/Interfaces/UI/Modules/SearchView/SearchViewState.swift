import Foundation
import Combine

class SearchPresenterPreviewer: SearchPresenter {
    @Published var state = SearchListState()
    
    init() {
        state.acceptingRequests = true
        state.tracks = [SearchedTrackViewModel.stub(), SearchedTrackViewModel.stub(), SearchedTrackViewModel.stub()]
        state.loadingTracks = [2: true]
        state.tracks[1].state = .notRequestable
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
    var randomTrack = RandomTrackViewModel(state: .requestable)
    var acceptingRequests: Bool = false
    var error: String?
    var loadingTracks = [Int: Bool]()
    var loadingRandom = false
    var canRequest: Bool = false
    var canRequestAt: String?
    
    static var initial = SearchListState()
    
    enum Mutation {
        case searchedTracks([SearchedTrackViewModel])
        case acceptingRequests(Bool)
        case loading(Int)
        case loadingRandom
        //        case randomTrack(RandomTrackViewModel)
        case error(String)
        case canRequestAt(String)
        case canRequest
        case cannotRequest
    }
    
    static func reduce(state: SearchListState, mutation: Mutation) -> SearchListState {
        var state = state
        
        switch mutation {
        case let .acceptingRequests(value):
            state.acceptingRequests = value
        case let .error(error):
            state.error = error
        //            case let .randomTrack(model):
        //                state.error = nil
        //                state.randomTrack = model
        case .loadingRandom:
            state.loadingRandom = true
        case let .searchedTracks(models):
            state.error = nil
            state.loadingTracks = [:]
            state.loadingRandom = false
            state.tracks = models
        case let .loading(index):
            state.loadingTracks[index] = true
        case let .canRequestAt(date):
            state.canRequestAt = date
            state.canRequest = false
            state.randomTrack.state = .notRequestable
        case .cannotRequest:
            state.canRequestAt = nil
            state.canRequest = false
            state.randomTrack.state = .notRequestable
        case .canRequest:
            state.canRequestAt = nil
            state.canRequest = true
            state.randomTrack.state = .requestable
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
