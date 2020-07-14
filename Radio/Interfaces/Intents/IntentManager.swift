import Foundation
import Intents

class IntentManager {
    
    init() {

    }
    
    private func requestPerms(onSuccess: @escaping ()->Void) {
        INPreferences.requestSiriAuthorization({ result in
            switch result {
            case .authorized:
                print("Siri allowed")
                onSuccess()
            case .denied, .notDetermined, .restricted:
                print("siri permission failed \(result)")
            @unknown default:
                print("siri permission unknown \(result)")
            }
        })
    }
    
    private func donateIntent(_ intent: INIntent) {
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
    
    func addQueueShortcut() {
        let intent = QueueIntent()
        intent.suggestedInvocationPhrase = "Show the song queue"
        
        let siriSearch = INSearchForMediaIntent()
        siriSearch.suggestedInvocationPhrase = "Search for"
        
        let shortcutSearch = SearchIntent()
        shortcutSearch.suggestedInvocationPhrase = "Search for"
        
        self.requestPerms(onSuccess: { [weak self] in
                            self?.donateIntent(intent)
                            self?.donateIntent(siriSearch)
                            self?.donateIntent(shortcutSearch)
        })
        
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
