import SwiftUI

struct MainTabsView: View {
    @State private var selection = 0
    
    let radioTab: RadioView
 
    var body: some View {
        TabView(selection: $selection){
            radioTab
                .tabItem {
                    VStack {
                        Image("second")
                        Text("tabs.radio")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("tabs.news")
                    }
                }
                .tag(1)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabsView(radioTab: RadioConfigurator().configure())
    }
}
