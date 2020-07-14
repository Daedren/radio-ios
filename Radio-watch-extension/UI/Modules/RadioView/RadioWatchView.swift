import SwiftUI
import Radio_app

enum RadioWatchViewAction: Equatable {
    case tappedPlayPause
}

struct RadioWatchView<P: RadioWatchPresenter>: View {
    @ObservedObject var presenter: P
    
    var body: some View {
        Group {
            VStack {
                Text(presenter.state.currentTrack?.artist ?? "")
                    .font(.footnote)
                Text(presenter.state.currentTrack?.title ?? "")
                    .font(.headline)
                Image(systemName: "play.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(.white))
                ProgressBar(barHeight: 5.0,
                            value: 0.5,
                            backgroundColor: .gray,
                            fillColor: .blue)
                HStack(spacing: 0) {
                    Text(presenter.state.currentTrack?.startTag ?? "")
                    Spacer()
                    Text(presenter.state.currentTrack?.endTag ?? "")
                }
                Text("DJ \(presenter.state.dj?.name ?? "??")")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                Spacer()
                HStack {
                    NavigationLink(destination: SongListView()) {
                        Image(systemName: "line.horizontal.3")
                    }                            .clipShape(Circle())
                    Spacer()
                    Button(action: tapped) {
                        Image(systemName: "mic")
                    }
                    .clipShape(Circle())
                }
            }
        }
        
    }
    
    func tapped() {
        
    }
}

struct RadioWatchView_Previews: PreviewProvider {
    static var previews: some View {
        RadioWatchConfigurator().configureFake()
    }
}
