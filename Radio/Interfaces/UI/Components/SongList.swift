import SwiftUI

struct SongList: View {
    var content: [TrackViewModel]
    var title: LocalizedStringKey
    var tableColor: UIColor
    let coloredNavAppearance = UINavigationBarAppearance()
    
    
    init(content: [TrackViewModel], title: LocalizedStringKey = "", tableColor: UIColor = .tertiarySystemBackground) {
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .secondarySystemBackground
        coloredNavAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        coloredNavAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UITableView.appearance().tableFooterView = UIView()
        UITableView.appearance().backgroundColor = .clear
        self.title = title
        self.content = content
        self.tableColor = tableColor
    }
    
    var body: some View {
        //        VStack {
        //            Text(title).font(.headline)
        //            List{
        //                Section(content: {
        //                    ForEach(content){
        //                        TrackView(track: $0)
        //                    }
        //                })
        //            }
        //        }
        VStack {
            if title != "" {
                NavigationView {
                    List{
                        Section( content: {
                            ForEach(content){
                                TrackView(track: $0)
                            }
                        })
                            .listRowBackground(Color(tableColor))
                    }
                    .navigationBarTitle(title, displayMode: .large)
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
