import Foundation
import Radio_domain
import Radio_data


public struct RandomTrackViewModel: Equatable, ButtonViewModel {
    public var state: ButtonViewModelStatus
    
    public init(state: ButtonViewModelStatus) {
        self.state = state
    }
    
    public func buttonText(for state: ButtonViewModelStatus) -> String {
        switch state {
        case .enabled:
            return "Random from results"
        case .disabled:
            return "Random from results"
        default:
            return ""
        }
    }

}

