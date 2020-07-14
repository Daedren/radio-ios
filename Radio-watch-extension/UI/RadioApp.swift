import SwiftUI

@main
struct RadioApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                RadioWatchConfigurator().configure()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
