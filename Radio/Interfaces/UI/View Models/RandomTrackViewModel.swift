import Foundation
import Radio_Domain

struct RandomTrackViewModel: Identifiable, RequestButtonViewModel {
    var id: Int
    var state: SearchTrackState
    
    func buttonText(for state: SearchTrackState) -> String {
        switch state {
        case .requestable:
            return "Request random track from list below"
        case .loading:
            return ""
        case .notRequestable:
            return "Cannot request at the moment"
        }
    }

}

