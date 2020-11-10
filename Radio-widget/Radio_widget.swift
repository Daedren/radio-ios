import WidgetKit
import SwiftUI
import Intents
import Combine
import Radio_domain
import Swinject

struct WidgetTrackViewModel: Identifiable, Equatable {
    var id: String {
        title+artist
    }
    
    public var title: String
    public var artist: String
    
    public var date: String
}

struct Provider: TimelineProvider {

    public typealias Entry = SimpleEntry
    
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        if context.isPreview {
            completion(SimpleEntry(date: Date(), tracks: []))
        } else {
            let configurator = IntentConfigurator()
            guard let songQueue = configurator.assembler.resolver.resolve(GetSongQueueInteractor.self),
            let updateUseCase = configurator.assembler.resolver.resolve(FetchRadioDataUseCase.self)
            else {
                completion(SimpleEntry(date: Date(), tracks: []))
                return
            }
            
            var queueDisposeBag = Set<AnyCancellable>()
            
            updateUseCase.execute(())
           
            songQueue
                .execute()
                .filter{ !$0.isEmpty }
                .first()
                .map{ tracks -> [WidgetTrackViewModel] in
                    return tracks.map { track -> WidgetTrackViewModel in
                        return WidgetTrackViewModel(title: track.title,
                                                    artist: track.artist,
                                                    date: "a")
                    }
                    
                }
                .sink(receiveCompletion: { _ in
                    
                }, receiveValue: { tracks in
                    completion(SimpleEntry(date: Date(), tracks: tracks))
                })
                .store(in: &queueDisposeBag)
            
        }
    }

    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
 

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(),
                           tracks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        completion(SimpleEntry(date: Date(),
                               tracks: []))
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let tracks: [WidgetTrackViewModel]
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder")
    }
}

struct Radio_widgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            List{
                ForEach(entry.tracks){
                    Text($0.title)
                }
            }
            Text("Loaded View")
        }
    }
}

@main
struct Radio_widget: Widget {
    private let kind: String = "Radio_widget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(),
                            content: { entry in
            Radio_widgetEntryView(entry: entry)
        })
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Radio_widget_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
