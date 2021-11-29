import SwiftUI

struct MainTabsView<A: View, B: View, C: View, D: View, E: View, F: View>: View {
    @State private var selection = 0
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var radioViewBig: A
    var radioViewSmall: A
    var tabTwo: B
    var lastPlayed: C
    var favorites: D
    var newsList: E
    var settings: F
    
    var body: some View {
        GeometryReader { geometry in
            if geometry.size.width > geometry.size.height {
                NavigationView {
                    radioViewBig
                    TabView(selection: $selection){
                        NavigationView {
                            lastPlayed
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .tabItem {
                            VStack {
                                Image(systemName: "backward.fill")
                                Text("Last Played")
                            }
                        }
                        .tag(0)
                        self.standardTabs
                    }
                }
            }
            else {
                TabView(selection: $selection){
                    radioViewSmall
                        .tabItem {
                            VStack {
                                Image(systemName: "hifispeaker.fill")
                                Text("R/a/dio")
                            }
                        }
                        .tag(0)
                    self.standardTabs
                }
            }
        }
    }
    
    var standardTabs: some View {
        Group {
            NavigationView {
                tabTwo
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                VStack {
                    Image(systemName: "envelope.fill")
                    Text("Search")
                }
            }
            .tag(1)
            
            NavigationView {
                favorites
                    .font(.title)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                VStack {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            }
            .tag(2)
            
            NavigationView {
                newsList
                    .font(.title)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("News")
                }
            }
            .tag(3)
            
            NavigationView {
                settings
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .font(.title)
            .tabItem {
                VStack {
                    Image(systemName: "circle.grid.2x2.fill")
                    Text("Settings")
                }
            }
            .tag(4)
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabsView(radioViewBig: RadioConfigurator().configureFake(),
                     radioViewSmall: RadioConfigurator().configureFake(),
                     tabTwo: Text("placeholder"),
                     lastPlayed: LastPlayedConfigurator().configureFake(),
                     favorites: FavoritesConfigurator().configure(),
                     newsList: NewsListConfigurator().configure(),
                     settings: SettingsConfigurator().configure())
            .preferredColorScheme(.dark)
    }
}
