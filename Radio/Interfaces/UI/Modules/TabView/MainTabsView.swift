import SwiftUI

struct MainTabsView<T: View>: View {
    @State private var selection = 0
    
    var tabOne: T
 
    var body: some View {
        TabView(selection: $selection){
            tabOne
                .tabItem {
                    VStack {
                        Image("second")
                        Text("R/a/dio")
                    }
                }
                .tag(0)
            Text("Second View")
                .font(.title)
                .tabItem {
                    VStack {
                        Image("second")
                        Text("News")
                    }
                }
                .tag(1)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabsView(tabOne: RadioConfigurator().configure())
    }
}
