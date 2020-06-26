import Foundation
import Radio_Domain

struct RandomTrackViewModel: Equatable, RequestButtonViewModel {
    var state: SearchTrackState
    
    func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Random from results"
        case .notRequestable:
            return "Random from results"
        }
    }

}

