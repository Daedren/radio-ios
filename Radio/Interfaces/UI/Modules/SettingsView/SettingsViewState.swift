import Foundation
import Radio_interfaces


struct SettingsPresenterState: Equatable {
    var options: [ListOptionViewModel] = []
    var sleepTimerEnabled = false
    var sleepTimer = Date()
    
    static var initial = SettingsPresenterState()
    
    enum Mutation {
        case options([ListOptionViewModel])
        case sleepTimer(Date)
        case toggleSleepTimer
    }
    
    static func reduce(state: SettingsPresenterState, mutation: Mutation) -> SettingsPresenterState {
        var state = state
        
        switch mutation {
        case let .options(newValue):
            state.options = newValue
        case let .sleepTimer(newValue):
            if newValue < Date(),
               let newDate = Calendar.current.date(byAdding: .hour, value: 1, to: newValue) {
                state.sleepTimer = newDate
            } else {
                state.sleepTimer = newValue
            }
        case .toggleSleepTimer:
            state.sleepTimerEnabled = !state.sleepTimerEnabled
        }
        
        return state
    }
    
    static func == (lhs: SettingsPresenterState, rhs: SettingsPresenterState) -> Bool {
            lhs.options == rhs.options &&
            lhs.sleepTimer == rhs.sleepTimer
    }
}
