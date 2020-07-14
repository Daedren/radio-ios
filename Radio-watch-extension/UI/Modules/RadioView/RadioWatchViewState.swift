import Foundation
import Radio_app
import Combine

struct RadioWatchViewState: Equatable {
    var currentTrack: CurrentTrackViewModel?
    var dj: DJViewModel?
    var listeners: Int?
    var isPlaying: Bool = false
    
    static var initial = RadioWatchViewState()
    
    enum Mutation {
        case currentTrack(CurrentTrackViewModel)
        case dj(DJViewModel)
        case status(listeners: Int)
        case isPlaying(Bool)
        case error(String)
    }
    
    static func reduce(state: RadioWatchViewState, mutation: Mutation) -> RadioWatchViewState {
        var state = state
        
        switch mutation {
        case let .currentTrack(newValue):
            state.currentTrack = newValue
        case let .dj(newValue):
            state.dj = newValue
        case let .status(listeners):
            state.listeners = listeners
        case let .isPlaying(value):
            state.isPlaying = value
        case .error(_):
            break
        }
        
        return state
    }
    
    static func == (lhs: RadioWatchViewState, rhs: RadioWatchViewState) -> Bool {
            lhs.currentTrack == rhs.currentTrack &&
            lhs.dj == rhs.dj &&
            lhs.listeners == rhs.listeners &&
            lhs.isPlaying == rhs.isPlaying
    }
}
