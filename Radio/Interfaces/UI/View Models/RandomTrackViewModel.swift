import Foundation
import Radio_Domain

struct RandomTrackViewModel: Identifiable, Equatable, RequestButtonViewModel {
    var id: Int
    var state: SearchTrackState
    
    func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Request random track from list below"
        case .notRequestable:
            return "Cannot request at the moment"
        }
    }

}

