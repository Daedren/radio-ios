import SwiftUI

struct LastPlayedView<P: LastPlayedPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
        VStack {
            SongList(content: self.presenter.lastPlayed, title: "Last Played")
        }
    }
}

struct LastPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        LastPlayedConfigurator().configureFake()
    }
}
