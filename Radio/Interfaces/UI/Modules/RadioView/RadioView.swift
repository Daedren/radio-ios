import SwiftUI
import UIKit
import KingfisherSwiftUI

struct RadioView<P: RadioPresenter>: View {
    @ObservedObject var presenter: P
    @State private var bottomSheetShown = false
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        Group {
            if verticalSizeClass == .regular {
                ZStack(alignment: .top){
                    self.djAndPlaybackView
                    GeometryReader { geometry in
                        BottomSheetView(isOpen: self.$bottomSheetShown,
                                        maxHeight: geometry.size.height * 0.9){
                                            VStack(spacing: 0.0) {
                                                SongList(content: self.presenter.lastPlayed, title: "Last Played")
                                            }
                        }
                    }
                }
            }
            else {
                HStack {
                    self.djAndPlaybackView
                        .frame(width: 250.0)
                    HStack {
                        SongList(content: self.presenter.queue, title: "Queue")
                        SongList(content: self.presenter.lastPlayed, title: "LastPlayed")
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.vertical)
    }
    
    var djAndPlaybackView: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    //                    presenter.dj.map{ self.djView(dj: $0, action: presenter.tappedButton)}
                    self.djView
                    VStack {
                        presenter.dj.map{Text($0.name)
                            .font(.headline)
                        }
                        presenter.listeners.map{ Text("Listeners: \($0)") }
                        
                    }
                }
            }
            presenter.currentTrack.map{SeekBarView(track: $0)}
            Text(presenter.currentTrack?.artist ?? "")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
            Text(presenter.currentTrack?.title ?? "")
                .font(.title)
                .multilineTextAlignment(.center)
            if presenter.acceptingRequests {
                SongList(content: self.presenter.queue, tableColor: .systemBackground)
            }
            if presenter.thread != "" {
                WebView(html: presenter.thread)
            }
        }
    }
    
    var djView: some View {
        VStack {
            presenter.dj.map{ dj in
                ZStack(alignment: .bottomTrailing){
                    KFImage(dj.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color(.label))
                        .frame(width: 150.0,
                               alignment: .center)
                        .clipShape(Circle())
                    Button(action: {
                        self.presenter.tappedButton()
                    }) {
                        Image(systemName: presenter.playText)
                            .resizable()
                            .scaledToFit()
                            .padding(10.0)
                            .foregroundColor(Color(.label))
                    }
                    .frame(width: 40.0, height: 40.0)
                    .background(Color.red)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color(.systemBackground), lineWidth: 2.0))
                }
            }
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
