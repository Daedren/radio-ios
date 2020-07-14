import SwiftUI
import Radio_app

struct LastPlayedView<P: LastPlayedPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
        VStack {
            SongList(content: self.presenter.lastPlayed, title: "Last Played",
                     topBarColor: .systemBackground,
                     tableColor: .secondarySystemBackground)
        }
    }
}

struct LastPlayedView_Previews: PreviewProvider {
    static var previews: some View {
        LastPlayedConfigurator().configureFake()
                     .environment(\.colorScheme, .dark)
    }
}
