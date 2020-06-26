import Foundation
import Combine

protocol RadioPresenter: ObservableObject {
    var state: RadioViewState { get }
    
    func start(actions: AnyPublisher<RadioViewAction, Never>)
}

struct RadioViewState: Equatable {
    var songName: String = ""
    var queue: [TrackViewModel] = []
    var lastPlayed: [TrackViewModel] = []
    var currentTrack: CurrentTrackViewModel?
    var dj: DJViewModel?
    var listeners: Int?
    var thread: String = ""
    var acceptingRequests: Bool = true
    var isPlaying: Bool = false
    
    static var initial = RadioViewState()
    
    enum Mutation {
        case queuedTracks([TrackViewModel])
        case lastPlayedTracks([TrackViewModel])
        case currentTrack(CurrentTrackViewModel)
        case dj(DJViewModel)
        case status(thread: String, listeners: Int, acceptingRequests: Bool)
        case isPlaying(Bool)
        case error(String)
    }
    
    static func reduce(state: RadioViewState, mutation: Mutation) -> RadioViewState {
        var state = state
        
        switch mutation {
        case let .queuedTracks(newValues):
            state.queue = newValues
        case let .lastPlayedTracks(newValues):
            state.lastPlayed = newValues
        case let .currentTrack(newValue):
            state.currentTrack = newValue
            state.songName = "\(newValue.artist) - \(newValue.title)"
        case let .dj(newValue):
            state.dj = newValue
        case let .status(thread, listeners, acceptingRequests):
            state.listeners = listeners
            state.thread = thread
            state.acceptingRequests = acceptingRequests
        case let .isPlaying(value):
            state.isPlaying = value
        case .error(_):
            break
        }
        
        return state
    }
    
    static func == (lhs: RadioViewState, rhs: RadioViewState) -> Bool {
        lhs.queue == rhs.queue &&
            lhs.lastPlayed == rhs.lastPlayed &&
            lhs.currentTrack == rhs.currentTrack &&
            lhs.dj == rhs.dj &&
            lhs.listeners == rhs.listeners &&
            lhs.thread == rhs.thread &&
            lhs.acceptingRequests == rhs.acceptingRequests &&
            lhs.isPlaying == rhs.isPlaying
    }
}
