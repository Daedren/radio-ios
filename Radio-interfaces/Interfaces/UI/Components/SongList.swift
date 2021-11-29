import Foundation
import SwiftUI

public struct SongList: View {
    var content: [TrackViewModel]
    var recycling = true
    var tableColor: Color
    
    
    public init(content: [TrackViewModel],
                tableColor: Color = RadioColors.secondarySystemBackground,
                recycling: Bool = true) {
//        UITableView.appearance().tableFooterView = UIView()
//        UITableView.appearance().backgroundColor = UIColor.clear
        self.content = content
        self.tableColor = tableColor
        self.recycling = recycling
    }
    
    
    
    public var body: some View {
        Group {
            if recycling {
                List{
                    ForEach(content){
                        TrackView(track: $0)
                    }
                    .listRowBackground(self.tableColor)
                }
                .animation(.default)
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
        SongList(content: [TrackViewModel.stub()],
                    tableColor: .gray)
                    .environment(\.colorScheme, .dark)
    }
}
