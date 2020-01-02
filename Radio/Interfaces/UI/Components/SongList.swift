import SwiftUI

struct SongList: View {
    var content: [TrackViewModel]
    var title: LocalizedStringKey
    var tableColor: UIColor

    
    init(content: [TrackViewModel], title: LocalizedStringKey = "", tableColor: UIColor = .tertiarySystemBackground) {
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = .clear
        self.title = title
        self.content = content
        self.tableColor = tableColor
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
                    List{
                        Section( content: {
                            ForEach(content){
                                TrackView(track: $0)
                            }
                        })
                            .listRowBackground(Color(tableColor))
                    }
                    .navigationBarTitle(title, displayMode: .inline)
                    .background(Color(tableColor))
                }
                
            }
            else {
                List{
                    Section( content: {
                        ForEach(content){
                            TrackView(track: $0)
                        }
                    })
                        .listRowBackground(Color(tableColor))
                }
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
