import UIKit
import SwiftUI
import IntentsUI

struct AddShortcutWrapper: UIViewControllerRepresentable {

    var intent: INIntent

    func makeUIViewController(context: UIViewControllerRepresentableContext<AddShortcutWrapper>) -> INUIAddVoiceShortcutViewController {
        if let shortcut = INShortcut(intent: intent) {
            let controller = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            return controller
        }
        fatalError()
    }

    func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController, context: UIViewControllerRepresentableContext<AddShortcutWrapper>) {}

}
