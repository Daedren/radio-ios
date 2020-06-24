import Foundation
import Intents

class IntentManager {
    init() {
        
    }
    
    func addQueueShortcut() {
        let intent = QueueIntent()
        
        intent.suggestedInvocationPhrase = "Show the song queue"
        
        let interaction = INInteraction(intent: intent, response: nil)
        
        interaction.donate { (error) in
            if error != nil {
                if let error = error as Error? {
                    print("Interaction donation failed: \(error.localizedDescription)")
                } else {
                    print("Successfully donated interaction")
                }
            }
        }
    }
    //
    //    func addQueueShortcut() {
    //        let bundle = Bundle.main.bundleIdentifier
    //        let activity = NSUserActivity(activityType: "\(bundle).siri.QueueIntent") // 1
    //        activity.title = "Get R/a/dio Queue" // 2
    //        activity.userInfo = ["speech" : "hi"] // 3
    //        activity.isEligibleForSearch = true // 4
    //        activity.isEligibleForPrediction = true // 5
    //        activity.persistentIdentifier =  NSUserActivityPersistentIdentifier("\(bundle).siri.QueueIntent")
    //        view.userActivity = activity // 7
    //        activity.becomeCurrent() // 8
    //    }
    
}
