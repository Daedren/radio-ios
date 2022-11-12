import SwiftUI

@main
struct RadioApp: App {
    @WKApplicationDelegateAdaptor var watchDelegate: WatchDelegate
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                RadioWatchConfigurator().configure()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
