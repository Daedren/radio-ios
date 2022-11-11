import WidgetKit
import SwiftUI
import Intents
import Combine
import Radio_domain
import Radio_data
import Radio_cross

struct WidgetViewState: Identifiable, Equatable {
    var id = UUID()
    
    var queue: [TrackViewModel] = []
    var lastPlayed: [TrackViewModel] = []
    var currentTrack: CurrentTrackViewModel?
    var dj: DJViewModel?
}

final class Provider: TimelineProvider {
    
    public typealias Entry = SimpleEntry
    var currQueue = [WidgetViewState]()
    var queueDisposeBag = Set<AnyCancellable>()
    
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        
        if context.isPreview {
            completion(SimpleEntry(date: Date(), tracks: []))
        } else {
            let configurator = IntentConfigurator()
            guard let songQueue = InjectSettings.shared.resolve(GetSongQueueInteractor.self),
                  let updateUseCase = InjectSettings.shared.resolve(FetchRadioDataUseCase.self),
                  let currentTrackInteractor = InjectSettings.shared.resolve(GetCurrentTrackUseCase.self),
                  let lastPlayedInteractor = InjectSettings.shared.resolve(GetLastPlayedInteractor.self),
                  let djInteractor = InjectSettings.shared.resolve(GetDJInteractor.self)
            else {
                completion(SimpleEntry(date: Date(), tracks: []))
                return
            }
            

            let main =
            updateUseCase.execute(())
                .flatMap {
                    songQueue.execute()
                }
                .catch{_ in return Just([QueuedTrack]())}
                .eraseToAnyPublisher()
                
            main.first()
                .combineLatest(currentTrackInteractor.execute(with: queueDisposeBag).first(),
                               lastPlayedInteractor.execute()
                                .catch{_ in return Just([QueuedTrack]())}
                                .first(),
                               djInteractor.execute()
                                .catch{_ in return Empty()}
                                .first())
                .sink(receiveValue: { queue, curr, last, dj in
                    let firstQueue = queue.first?.startTime ?? Date()
                    let state = WidgetViewState(
                        queue: queue.map{ return TrackViewModel(base: $0)},
                        lastPlayed: last.map{ return TrackViewModel(base: $0)},
                        currentTrack: CurrentTrackViewModel(base: curr),
                        dj: DJViewModel(base: dj))
                    
                    completion(SimpleEntry(date: firstQueue,
                                           tracks: [state]))
                })
                .store(in: &queueDisposeBag)
            
        }
    }
    
    public func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        snapshot(with: context, completion: { newEntry in
            let timeline = Timeline(entries: [newEntry], policy: .atEnd)
            completion(timeline)
        })
    }
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(),
                           tracks: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        snapshot(with: context, completion: completion)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let tracks: [WidgetViewState]
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
