import SwiftUI

struct RadioView: View {
    @ObservedObject var presenter: RadioPresenter
    
    var body: some View {
        VStack {
            Text("asdasda")
            Text(presenter.songName)
            Button(action: presenter.tappedButton) {
                Text("botan")
            }
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioConfigurator().configure()
    }
}
