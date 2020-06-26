import Foundation
import SwiftUI

enum SearchTrackState {
    case requestable
    case notRequestable
}

protocol RequestButtonViewModel {
    var state: SearchTrackState { get set }
    func buttonText(for state: SearchTrackState) -> String
}

struct SongRequestButton: View {
    
    var viewModel: RequestButtonViewModel
    var isLoading: Bool = false
    
    var action: (() -> ())
    
    init(viewModel: RequestButtonViewModel, isLoading: Bool, action: @escaping (() -> ())) {
        self.viewModel = viewModel
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: {
            self.action()
        }) {
            if self.isLoading {
                ActivityIndicatorWrapper(style: .medium)
                    .padding([.leading,. trailing], nil)
            } else {
                Text(self.viewModel.buttonText(for: self.viewModel.state))
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
            }
        }
        .padding([.leading,. trailing], 15.0)
        .padding([.top, .bottom], 10.0)
        .background(Color.red)
        .clipShape(RoundedRectangle(cornerRadius: 30.0))
        .opacity(self.viewModel.state == .requestable ? 1 : 0.4)
        .animation(Animation.default.speed(1))
    }

}

//struct RadioButton_Previews: PreviewProvider {
//    static var previews: some View {
//        return RadioButton(action: nil, state: .loading)
//    }
//}
