import SwiftUI

struct MainTabsView<A: View, B: View, C: View, D: View, E: View, F: View>: View {
    @State private var selection = 0
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var largeWidthClass: Bool {
        horizontalSizeClass == .regular || (horizontalSizeClass == .compact && verticalSizeClass == .compact)
    }
    
    var tabOne: A
    var tabTwo: B
    var lastPlayed: C
    var favorites: D
    var newsList: E
    var settings: F
    
    var body: some View {
        Group {
            if largeWidthClass {
                NavigationView {
                    tabOne
                    TabView(selection: $selection){
                        lastPlayed
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
                    tabOne
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
            tabTwo
                .tabItem {
                    VStack {
                        Image(systemName: "envelope.fill")
                        Text("Search")
                    }
            }
            .tag(1)
            favorites
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "heart.fill")
                        Text("Favorites")
                    }
            }
            .tag(2)
            newsList
                .font(.title)
                .tabItem {
                    VStack {
                        Image(systemName: "house.fill")
                        Text("News")
                    }
            }
            .tag(3)
            settings
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
        MainTabsView(tabOne: RadioConfigurator().configureFake(),
                     tabTwo: Text("placeholder"),
                     lastPlayed: LastPlayedConfigurator().configureFake(),
                     favorites: FavoritesConfigurator().configure(),
                     newsList: NewsListConfigurator().configure(),
                     settings: SettingsConfigurator().configure())
            .preferredColorScheme(.dark)
    }
}
