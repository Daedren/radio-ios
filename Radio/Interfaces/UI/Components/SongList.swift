import SwiftUI
import Radio_app

struct SongList: View {
    var content: [TrackViewModel]
    var recycling = true
    var title: LocalizedStringKey
    var tableColor: UIColor
    var topBarColor: UIColor

    
    init(content: [TrackViewModel],
         title: LocalizedStringKey = "",
         topBarColor: UIColor = .systemBackground,
         tableColor: UIColor = .secondarySystemBackground,
         recycling: Bool = true) {
        UITableView.appearance().tableFooterView = UIView()
//        UITableView.appearance().backgroundColor = .clear
        self.title = title
        self.content = content
        self.tableColor = tableColor
        self.topBarColor = topBarColor
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
                    .background(Color(topBarColor))
                    
                    songList
                    .navigationBarTitle(title, displayMode: .inline)
                        .background(Color(.systemBackground))
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
