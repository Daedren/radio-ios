import SwiftUI
import Radio_interfaces

public struct SongListiOS: View {
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
        
        self.title = title
        self.content = content
        self.tableColor = tableColor
        self.topBarColor = topBarColor
        self.recycling = recycling
    }
    
    public var body: some View {
        VStack {
            if title != "" {
                VStack(spacing: 0.0) {
                    HStack {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.leading, 10.0)
                    .padding(.top, 20.0)
                    
                    SongList(content: content, tableColor: tableColor, recycling: recycling)
                    .navigationBarTitle(title, displayMode: .inline)
                }
                .background(self.topBarColor)
                
            }
            else {
                SongList(content: content, tableColor: tableColor, recycling: recycling)
            }
            
        }
    }
}

public struct SongList_Previews: PreviewProvider {
    public static var previews: some View {
        SongListiOS(content: [TrackViewModel.stub()], title: "Queue",
                    topBarColor: Color(.systemGroupedBackground),
                    tableColor: .gray)
//                    .environment(\.colorScheme, .dark)
    }
}
