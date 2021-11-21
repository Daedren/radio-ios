import SwiftUI

public struct SongList: View {
    var content: [TrackViewModel]
    var recycling = true
    var title: LocalizedStringKey
    var tableColor: Color
    var topBarColor: Color

    
    public init(content: [TrackViewModel],
         title: LocalizedStringKey = "",
         topBarColor: Color = RadioColors.systemBackground,
         tableColor: Color = RadioColors.secondarySystemBackground,
         recycling: Bool = true) {
        UITableView.appearance().tableFooterView = UIView()
//        UITableView.appearance().backgroundColor = .clear
        self.title = title
        self.content = content
        self.tableColor = tableColor
        self.topBarColor = topBarColor
        self.recycling = recycling
    }
    
    public var body: some View {
        VStack {
            if title != "" {
                VStack(spacing:0.0){
                    HStack(spacing: 10.0){
                        Text(title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                    .frame(height: 100.0)
                    .background(topBarColor)
                    
                    songList
                    .navigationBarTitle(title, displayMode: .inline)
                    .background(RadioColors.systemBackground)
                }
                
            }
            else {
                songList
            }
            
        }
    }
    
    var songList: some View {
        Group {
            if recycling {
                List{
                        ForEach(content){
                            TrackView(track: $0)
                        }
                        .listRowBackground(self.tableColor)
                }
            }
            else {
                VStack {
                    ForEach(content) { item in
                        TrackView(track: item)
                        Divider()
                    }
                }.padding(.vertical, 30)
            }
        }
    }
}

public struct SongList_Previews: PreviewProvider {
    public static var previews: some View {
        SongList(content: [TrackViewModel.stub()], title: "Queue", tableColor: .gray)
        //            .environment(\.colorScheme, .dark)
    }
}
