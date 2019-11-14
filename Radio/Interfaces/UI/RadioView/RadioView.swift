import SwiftUI
import UIKit

struct RadioView: View {
    @ObservedObject var presenter: RadioPresenter
    
    var body: some View {
        VStack {
            Text("asdasda")
            Text(presenter.songName)
            Button(action: {
                self.presenter.tappedButton()
            }) {
                Text(presenter.playText)
            }
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioConfigurator().configure()
    }
}

struct GoddamnitView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<GoddamnitView>) -> UIView {
        let view = UIView()
        view.becomeFirstResponder()
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<GoddamnitView>) {
        uiView.becomeFirstResponder()
    }
    
    typealias UIViewType = UIView
    
    
}
