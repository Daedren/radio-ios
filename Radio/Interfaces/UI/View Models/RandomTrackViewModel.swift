import Foundation
import Radio_Domain

struct RandomTrackViewModel: Equatable, RequestButtonViewModel {
    var state: SearchTrackState
    
    func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Random track from below"
        case .notRequestable:
            return "Cannot request at the moment"
        }
    }

}

