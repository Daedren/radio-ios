import UIKit
import SwiftUI
import IntentsUI

public struct AddShortcutWrapper: UIViewControllerRepresentable {
    var intent: INIntent
    
    public init(intent: INIntent) {
        self.intent = intent
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<AddShortcutWrapper>) -> INUIAddVoiceShortcutViewController {
        if let shortcut = INShortcut(intent: intent) {
            let controller = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            return controller
        }
        fatalError()
    }

    public func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController, context: UIViewControllerRepresentableContext<AddShortcutWrapper>) {}

}
