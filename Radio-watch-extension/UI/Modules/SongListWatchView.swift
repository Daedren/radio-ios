import SwiftUI

struct SongListView: View {
    var body: some View {
        TabView{
            VStack {
                Text("a")
            }
                .tabItem {
                    Text("Last played")
                }
            Text("q")
                .tabItem {
                    Text("Queue")
                }
        }
    }
}

struct SongListView_Previews: PreviewProvider {
    static var previews: some View {
        SongListView()
    }
}
