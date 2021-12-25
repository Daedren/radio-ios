import Foundation
import Intents
import IntentsUI

enum IntentModel: Int {
   case queue
//    case siriSearch
    case shortcutSearch
    
    var title: String {
        switch self {
        case .queue:
            return "Queue"
//        case .siriSearch:
//            return "Siri search"
        case .shortcutSearch:
            return "Shortcut search"
        }
    }
}

class IntentManager {
    var intents: [IntentModel: INIntent] = [:]
    
    init() {
        self.intents = createIntents()
    }
    
    private func createIntents() -> [IntentModel: INIntent] {
        let intent = QueueIntent()
        intent.suggestedInvocationPhrase = "Show the R/a/dio queue"
        
//        let siriSearch = INSearchForMediaIntent()
//        siriSearch.suggestedInvocationPhrase = "Search R/a/dio"
        
        let shortcutSearch = SearchIntent()
        shortcutSearch.suggestedInvocationPhrase = "Search R/a/dio"
        
        return [.queue: intent,
//                .siriSearch: siriSearch,
                .shortcutSearch: shortcutSearch]
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
    
    func getIntents() -> [IntentModel] {
        return Array(self.intents.keys)
    }
    
    func donate(intent: IntentModel) {
        if let actualIntent = self.intents[intent] {
            self.requestPerms(onSuccess: { [weak self] in
                                self?.donateIntent(actualIntent)
            })
        }
    }
    
    func get(intent: IntentModel) -> INIntent? {
        if let actualIntent = self.intents[intent] {
            return actualIntent
        }
        return nil
    }
}
