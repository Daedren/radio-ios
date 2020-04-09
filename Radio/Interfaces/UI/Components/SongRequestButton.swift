import Foundation
import SwiftUI

enum SearchTrackState {
    case requestable
    case loading
    case notRequestable
    
    func getText() -> String {
        switch self {
        case .requestable:
            return "Request"
        case .loading:
            return ""
        case .notRequestable:
            return "Requestable soon"
        }
    }
}

struct SongRequestButton: View {
    
    let index: Int
    var track: SearchedTrackViewModel
    var action: ((Int) -> Void)?

    var body: some View {
        Button(action: {
            self.action?(self.index)
        }) {
            if self.track.state == .loading {
                ActivityIndicatorWrapper(style: .medium)
                    .padding([.leading,. trailing], nil)
            }
            else {
                Text(self.track.state.getText())
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .opacity(self.track.state == .requestable ? 1 : 0.4)
        .animation(Animation.default.speed(1))
    }

}

struct SongRequestButton_Previews: PreviewProvider {
    static var previews: some View {
        var stub = SearchedTrackViewModel.stub()
        stub.state = .loading
        return SongRequestButton(index: 0, track: stub, action: nil)
    }
}
