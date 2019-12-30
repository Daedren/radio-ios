import SwiftUI
import UIKit

struct RadioView<P: RadioPresenter>: View {
    @ObservedObject var presenter: P
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            if verticalSizeClass == .regular {
                VStack {
                    self.djAndPlaybackView
                        .frame(height: 300.0)
                    VStack {
                        self.queue
                        self.lastPlayed
                    }
                }
            }
            else {
                HStack {
                    self.djAndPlaybackView
                        .frame(width: 250.0)
                    HStack {
                        self.queue
                        self.lastPlayed
                    }
                }
            }
        }
    }
    
    var djAndPlaybackView: some View {
        VStack {
            presenter.dj.map{ DJView(dj: $0)}
            Button(action: {
                self.presenter.tappedButton()
            }) {
                Text(presenter.playText)
            }
            Text(presenter.songName)
                .multilineTextAlignment(.center)
            presenter.currentTrack.map{SeekBarView(track: $0)}
            presenter.listeners.map{ Text("Listeners: \($0)") }
        }
    }
    
    var queue: some View {
        List{
            Section(header: Text("Last Played"), content: {
                ForEach(presenter.lastPlayed){
                    TrackView(track: $0)
                }
            })
        }
    }
    var lastPlayed: some View {
        List{
            Section(header: Text("Queue"), content: {
                ForEach(presenter.queue){
                    TrackView(track: $0)
                }
            })
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let nextPreview = RadioConfigurator().configureFake()
//            .environment(\.colorScheme, .dark)
//            .previewLayout(.fixed(width: 700, height: 350))
//            .environment(\.verticalSizeClass, .compact)
            .environment(\.verticalSizeClass, .regular)
        return nextPreview
    }
}
