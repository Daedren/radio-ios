import Foundation
import Intents


struct SiriSettingsPresenterState: Equatable {
    var options: [ListOptionViewModel] = []
    var intent: INIntent?
    
    static var initial = SiriSettingsPresenterState()
    
    enum Mutation {
        case options([ListOptionViewModel])
        case tappedIntent(INIntent)
    }
    
    static func reduce(state: SiriSettingsPresenterState, mutation: Mutation) -> SiriSettingsPresenterState {
        var state = state
        
        switch mutation {
        case let .options(newValue):
            state.options = newValue
            state.intent = nil
        case let .tappedIntent(newValue):
            state.intent = newValue
        }
        
        return state
    }
    
    static func == (lhs: SiriSettingsPresenterState, rhs: SiriSettingsPresenterState) -> Bool {
            lhs.options == rhs.options &&
                lhs.intent == rhs.intent
    }
}
