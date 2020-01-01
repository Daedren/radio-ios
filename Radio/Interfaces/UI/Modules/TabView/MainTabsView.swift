import SwiftUI

struct MainTabsView<A: View, B: View>: View {
    @State private var selection = 0
    
    var tabOne: A
    var tabTwo: B
 
    var body: some View {
        TabView(selection: $selection){
            tabOne
                .tabItem {
                    VStack {
                        Image(systemName: "hifispeaker.fill")
                        Text("R/a/dio")
                    }
                }
                .tag(0)
            tabTwo
                .tabItem {
                    VStack {
                        Image(systemName: "envelope.fill")
                        Text("Search")
                    }
            }
            .tag(1)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("News")
                    }
                }
                .tag(2)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabsView(tabOne: RadioConfigurator().configure(),
                     tabTwo: Text("placeholder"))
    }
}
