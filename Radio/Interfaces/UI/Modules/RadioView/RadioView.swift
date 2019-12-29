import SwiftUI
import UIKit

struct RadioView<P: RadioPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
        VStack {
            presenter.dj.map{ DJView(dj: $0)}
            Button(action: {
                self.presenter.tappedButton()
            }) {
                Text(presenter.playText)
            }
            Text(presenter.songName)
            presenter.listeners.map{ Text("Listeners: \($0)") }
            VStack {
                List{
                    Section(header: Text("Last Played"), content: {
                        ForEach(presenter.lastPlayed){
                            TrackView(track: $0)
                        }
                    })
                }
                List{
                    Section(header: Text("Queue"), content: {
                        ForEach(presenter.queue){
                            TrackView(track: $0)
                        }
                    })
                }
            }
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let nextPreview = RadioConfigurator().configureFake()
        return nextPreview
    }
}
