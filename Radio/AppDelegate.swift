import UIKit
import Intents
import Radio_interfaces
import Radio_cross
import Radio_domain

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var playerInterface: MediaPlayerInterface?
    var mainInjection: Configurator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if mainInjection == nil {
            self.mainInjection = Configurator()
        }
        self.playerInterface = MediaPlayerConfigurator().configure()
        return true
    }
    
    func application(_ application: UIApplication, handlerFor intent: INIntent) -> Any? {
        if mainInjection == nil {
            self.mainInjection = Configurator()
        }
        switch intent {
            case is INPlayMediaIntent:
                return PlayIntentHandler(playUseCase: InjectSettings.shared.resolve(PlayRadioUseCase.self)!)
            default:
                return nil
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

