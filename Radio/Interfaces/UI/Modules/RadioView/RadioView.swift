import SwiftUI
import Combine
import Radio_interfaces

enum RadioViewAction: Equatable {
    case tappedPlayPause
    case tappedTitle
}

struct RadioView<P: RadioPresenter>: View {
    @ObservedObject var presenter: P
    @State private var bottomSheetShown = false
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    let bigVersion: Bool
    
    var actions = PassthroughSubject<RadioViewAction, Never>()
    
    init(presenter: P, bigVersion: Bool) {
        self.presenter = presenter
        self.bigVersion = bigVersion
        
        self.presenter.start(actions:
                                actions.eraseToAnyPublisher())
        print("starting \(bigVersion)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            if !bigVersion {
                smallScreensView
            }
            else {
                bigScreensView
            }
        }
    }
    
    var smallScreensView: some View {
        VStack {
        self.djAndPlaybackView
        TabView {
            VStack {
                if presenter.state.acceptingRequests {
                    SongListiOS(content: self.presenter.state.queue,
                                title: "Queue",
                                topBarColor: Color(.systemGroupedBackground),
                                tableColor: RadioColors.tertiarySystemBackground)
                }
                else if presenter.state.thread != "" {
                    WebView(application: UIApplication.shared,
                            html: presenter.state.thread)
                }
                else {
                    Text("There is currently no thread up.")
                }
                Spacer()
            }
            VStack {
                SongListiOS(content: self.presenter.state.lastPlayed,
                         title: "Last Played",
                         topBarColor: Color(.systemGroupedBackground),
                         tableColor: RadioColors.tertiarySystemBackground)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        }
    }
    
    var bigScreensView: some View {
        VStack {
            self.djAndPlaybackView
            if presenter.state.acceptingRequests {
                SongList(content: self.presenter.state.queue, tableColor: RadioColors.systemBackground)
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
    
    private func tappedPlayPause() {
        self.actions.send(.tappedPlayPause)
    }

    private func tappedTitle() {
        self.actions.send(.tappedTitle)
    }

    
    var djAndPlaybackView: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                HStack {
                    DJView(
                        dj: presenter.state.dj,
                        isPlaying: presenter.state.isPlaying,
                        action: self.tappedPlayPause)
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
            Text(presenter.state.currentTrack?.title ?? "")
                .font(.title)
                .multilineTextAlignment(.center)
                .onTapGesture(perform: self.tappedTitle)
            if presenter.state.showTags {
                Text(presenter.state.currentTrack?.tags ?? "")
                    .font(.caption2)
                    .foregroundColor(Color(.secondaryLabel))
                    .multilineTextAlignment(.center)
            }
        }
        .animation(.easeInOut(duration: 0.3))
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let nextPreview = RadioConfigurator().configureFake()
//            .environment(\.horizontalSizeClass, .regular)
//            .environment(\.verticalSizeClass, .compact)
//            .previewDevice(PreviewDevice(rawValue: "iPad Pro (9.7-inch)"))
            .previewDevice(PreviewDevice(rawValue: "iPhone 12"))
//                    .previewLayout(.fixed(width: 700, height: 350))
//                    .previewLayout(.fixed(width: 1200, height: 500))
        //            .environment(\.verticalSizeClass, .compact)
        return nextPreview
    }
}
