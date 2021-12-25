import Foundation
import SwiftUI
import Radio_data

public enum ButtonViewModelStatus: Equatable {
    case enabled
    case disabled
    case loading
}

public protocol ButtonViewModel {
    var state: ButtonViewModelStatus { get }
    func buttonText(for state: ButtonViewModelStatus) -> String
}

public struct SongRequestButton: View {
    
    var viewModel: ButtonViewModel
    var action: ((ButtonViewModel) -> ())
    var status: ButtonViewModelStatus
    
    
    public init(viewModel: ButtonViewModel, action: @escaping ((ButtonViewModel) -> ())) {
        self.viewModel = viewModel
        self.status = viewModel.state
        self.action = action
    }

    public var body: some View {
        Button(action: {
            self.action(self.viewModel)
        }) {
            if self.status == .loading {
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
        .opacity(self.status == .enabled ? 1 : 0.4)
        .animation(Animation.default.speed(1), value: self.status)
    }

}

//struct RadioButton_Previews: PreviewProvider {
//    static var previews: some View {
//        return RadioButton(action: nil, state: .loading)
//    }
//}
