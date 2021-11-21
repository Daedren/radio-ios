import SwiftUI
import UIKit
import Combine
import KingfisherSwiftUI
import Radio_interfaces

enum RadioViewAction: Equatable {
    case tappedPlayPause
}

struct RadioView<P: RadioPresenter>: View {
    @ObservedObject var presenter: P
    @State private var bottomSheetShown = false
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var largeWidthClass: Bool {
        horizontalSizeClass == .regular || (horizontalSizeClass == .compact && verticalSizeClass == .compact)
    }
    
    var actions = PassthroughSubject<RadioViewAction, Never>()
    
    init(presenter: P) {
        self.presenter = presenter
        
        self.presenter.start(actions:
            actions.eraseToAnyPublisher())
    }
    
    var body: some View {
        Group {
            if !largeWidthClass {
                ZStack(alignment: .top){
                    VStack {
                        self.djAndPlaybackView
                        if presenter.state.acceptingRequests {
                            SongList(content: self.presenter.state.queue, tableColor: .systemBackground)
                        }
                        else if presenter.state.thread != "" {
                            WebView(application: UIApplication.shared,
                                    html: presenter.state.thread)
                        }
                     Spacer()
                    }
                    GeometryReader { geometry in
                        BottomSheetView(isOpen: self.$bottomSheetShown,
                                        maxHeight: geometry.size.height * 0.9){
                                            VStack(spacing: 0.0) {
                                                SongList(content: self.presenter.state.lastPlayed,
                                                         title: "Last Played",
                                                         topBarColor: .secondarySystemBackground,
                                                         tableColor: .tertiarySystemBackground)
                                            }
                        }
                    }
                }
            }
            else {
                VStack {
                    self.djAndPlaybackView
//                        .frame(width: 250.0)
                    if presenter.state.acceptingRequests {
                        SongList(content: self.presenter.state.queue, tableColor: .systemBackground)
                    }
                    else if presenter.state.thread != "" {
                        WebView(application: UIApplication.shared,
                                html: presenter.state.thread)
                    }
//                    if let scales = self.presenter.state.scales {
//                        BarChartView(viewModel: scales)
//                    }
//                    MTKViewWrapper(scales: presenter.scales)
                }
            }
        }
//        .edgesIgnoringSafeArea(.vertical)
    }
    
    var djAndPlaybackView: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    //                    presenter.dj.map{ self.djView(dj: $0, action: presenter.tappedButton)}
                    self.djView
                    VStack {
                        presenter.state.dj.map{
                            Text($0.name)
                            .font(.headline)
                            .lineLimit(1)
                            .frame(alignment: .center)
                        }
                        presenter.state.listeners.map{
                            Text("Listeners: \($0)")
                            .frame(alignment: .center)
                        }
                        
                    }
                }
            }
            presenter.state.currentTrack.map{SeekBarView(track: $0)}
            Text(presenter.state.currentTrack?.artist ?? "")
                .font(.subheadline)
                .foregroundColor(Color(.secondaryLabel))
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.3))
            Text(presenter.state.currentTrack?.title ?? "")
                .font(.title)
                .multilineTextAlignment(.center)
                .animation(.easeInOut(duration: 0.3))
        }
    }
    
    var djView: some View {
        VStack {
            presenter.state.dj.map{ dj in
                ZStack(alignment: .bottomTrailing){
                    KFImage(dj.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .background(Color(.label))
                        .frame(width: 150.0,
                               alignment: .center)
                        .clipShape(Circle())
                    Button(action: {
                        self.actions.send(.tappedPlayPause)
                    }) {
                        Image(systemName: presenter.state.isPlaying ? "stop.fill" : "play.fill")
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
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .compact)
            .previewDevice(PreviewDevice(rawValue: "iPad Pro (11-inch)"))
//             .environment(\.colorScheme, .dark)
//            .previewLayout(.fixed(width: 700, height: 350))
//            .previewLayout(.fixed(width: 1200, height: 500))
            //            .environment(\.verticalSizeClass, .compact)
        return nextPreview
    }
}
