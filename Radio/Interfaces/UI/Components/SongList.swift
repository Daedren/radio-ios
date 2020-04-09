import SwiftUI

struct SongList: View {
    var content: [TrackViewModel]
    var recycling = true
    var title: LocalizedStringKey
    var tableColor: UIColor

    
    init(content: [TrackViewModel], title: LocalizedStringKey = "", tableColor: UIColor = .tertiarySystemBackground, recycling: Bool = true) {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = .clear
        self.title = title
        self.content = content
        self.tableColor = tableColor
        self.recycling = recycling
    }
    
    var body: some View {
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
                    .background(Color(.secondarySystemBackground))
                    
                    songList
                    .navigationBarTitle(title, displayMode: .inline)
                    .background(Color(tableColor))
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
                    Section( content: {
                        ForEach(content){
                            TrackView(track: $0)
                        }
                    })
                        .listRowBackground(Color(tableColor))
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

struct SongList_Previews: PreviewProvider {
    static var previews: some View {
        SongList(content: [TrackViewModel.stub()], title: "Queue", tableColor: .gray)
        //            .environment(\.colorScheme, .dark)
    }
}
