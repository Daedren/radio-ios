import Foundation


struct SettingsPresenterState: Equatable {
    var options: [ListOptionViewModel] = []
    
    static var initial = SettingsPresenterState()
    
    enum Mutation {
        case options([ListOptionViewModel])
    }
    
    static func reduce(state: SettingsPresenterState, mutation: Mutation) -> SettingsPresenterState {
        var state = state
        
        switch mutation {
        case let .options(newValue):
            state.options = newValue
        }
        
        return state
    }
    
    static func == (lhs: SettingsPresenterState, rhs: SettingsPresenterState) -> Bool {
            lhs.options == rhs.options
    }
}
