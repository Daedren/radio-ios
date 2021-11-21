import Foundation
import Radio_domain
import Radio_data


public struct RandomTrackViewModel: Equatable, RequestButtonViewModel {
    public var state: SearchTrackState
    
    public init(state: SearchTrackState) {
        self.state = state
    }
    
    public func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Random from results"
        case .notRequestable:
            return "Random from results"
        }
    }

}

