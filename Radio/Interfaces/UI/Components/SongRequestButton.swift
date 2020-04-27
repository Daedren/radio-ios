import Foundation
import SwiftUI

enum SearchTrackState {
    case requestable
    case loading
    case notRequestable
}

protocol RequestButtonViewModel {
    var state: SearchTrackState { get set }
    func buttonText(for state: SearchTrackState) -> String
}

struct SongRequestButton<P: RequestButtonViewModel>: View {
    
    var viewModel: P
    
    var action: ((P) -> Void)?

    var body: some View {
        Button(action: {
            self.action?(self.viewModel)
        }) {
            if self.viewModel.state == .loading {
                ActivityIndicatorWrapper(style: .medium)
                    .padding([.leading,. trailing], nil)
            }
            else {
                Text(self.viewModel.buttonText(for: self.viewModel.state))
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 10.0))
        .opacity(self.viewModel.state == .requestable ? 1 : 0.4)
        .animation(Animation.default.speed(1))
    }

}

//struct RadioButton_Previews: PreviewProvider {
//    static var previews: some View {
//        return RadioButton(action: nil, state: .loading)
//    }
//}
