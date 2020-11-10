import Foundation
import SwiftUI
import Intents

struct WireframeDestination: Identifiable {
    var id: INIntent
}
class SiriSettingsWireframe {
    enum destinations: Int {
        case addShortcut
    }
    
    func destination(_ tag: WireframeDestination) -> some View {
        return AddShortcutWrapper(intent: tag.id)
    }
}
