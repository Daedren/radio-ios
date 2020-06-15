import Foundation
import Combine

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
    
    static var initial = SearchListState()
    
    enum Mutation {
        case searchedTracks([SearchedTrackViewModel])
        case acceptingRequests(Bool)
        case loading(Int)
        case loadingRandom
        case randomTrack(RandomTrackViewModel)
        case error(String)
    }

    static func reduce(state: SearchListState, mutation: Mutation) -> SearchListState {
        var state = state
        
        switch mutation {
            case let .acceptingRequests(value):
                state.acceptingRequests = value
            case let .error(error):
                state.error = error
            case let .randomTrack(model):
                state.error = nil
                state.randomTrack = model
            case .loadingRandom:
                state.loadingRandom = true
            case let .searchedTracks(models):
                state.error = nil
                state.loadingTracks = [:]
                state.loadingRandom = false
                state.tracks = models
            case let .loading(index):
                state.loadingTracks[index] = true
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
