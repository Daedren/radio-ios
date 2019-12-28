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
            HStack {
                List{
                    Section(header: Text("tabs.queue"), content: {
                        ForEach(presenter.queue){
                            TrackView(track: $0)
                        }
                    })
                }
                List{
                    Section(header: Text("tabs.lastPlayed"), content: {
                        ForEach(presenter.lastPlayed){
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
