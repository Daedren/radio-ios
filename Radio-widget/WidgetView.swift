import Foundation
import WidgetKit
import SwiftUI


struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder")
    }
}

struct Radio_widgetEntryView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry = Provider.Entry(date: Date(),
                                               tracks: [])
    
    var body: some View {
        switch family {
        case .systemSmall: smallFamilyView(entry.tracks.first)
        case .systemMedium: mediumFamilyView(entry.tracks.first)
        case .systemLarge: mediumFamilyView(entry.tracks.first)
        default: smallFamilyView(entry.tracks.first)
        }
    }
    
    func mainView(_ state: WidgetViewState?) -> some View {
        VStack {
            GeometryReader { geometry in
                NetworkImage(url: state?.dj?.image)
                    .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height/1.3,
                           alignment: .leading)
                    .padding()
                //                Image("radio_lady")
                //                    .resizable()
                //                    .position(x: geometry.size.width-30, y: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
                //                    .frame(width: 20, height: 20, alignment: .trailing)
                //                    .opacity(0.5)
                //                    .padding()
            }
            Group {
                Text(state?.currentTrack?.artist ?? "")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(state?.currentTrack?.title ?? "")
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding([.leading, .trailing])
            Spacer()
        }
    }
    
    func smallFamilyView(_ state: WidgetViewState?) -> some View {
        mainView(state)
    }
    
    func mediumFamilyView(_ state: WidgetViewState?) -> some View {
        Group {
            HStack {
                mainView(state)
            VStack {
                Text("Upcoming")
                    .font(.caption)
                ForEach(Array(state?.queue ?? [])) { item in
                    Text("\(item.artist) - \(item.title)")
                        .font(.caption2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding([.trailing])
            }
        }
    }
    
    func largeFamilyView(_ state: WidgetViewState?) -> some View {
        VStack {
            Text("")
        }
    }
    
}


struct WidgetView_Previews: PreviewProvider {
    
    static var previews: some View {
        let entry = Provider.Entry(date: Date(), tracks: [WidgetViewState(queue: [TrackViewModel.stub(), TrackViewModel.stub(), TrackViewModel.stub(), TrackViewModel.stub(), TrackViewModel.stub()], lastPlayed: [TrackViewModel.stub()], currentTrack: CurrentTrackViewModel.stubCurrent(), dj: DJViewModel.stub())])
        Radio_widgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        Radio_widgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        Radio_widgetEntryView(entry: entry)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
