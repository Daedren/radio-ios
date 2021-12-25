import UIKit
import SwiftUI
import IntentsUI

public struct AddShortcutWrapper: UIViewControllerRepresentable {
    var intent: INIntent
    var delegate: INUIAddVoiceShortcutViewControllerDelegate
    
    public init(intent: INIntent) {
        self.intent = intent
        self.delegate = Delegate()
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<AddShortcutWrapper>) -> INUIAddVoiceShortcutViewController {
        if let shortcut = INShortcut(intent: intent) {
            let controller = INUIAddVoiceShortcutViewController(shortcut: shortcut)
            controller.delegate = self.delegate
            return controller
        }
        fatalError()
    }

    public func updateUIViewController(_ uiViewController: INUIAddVoiceShortcutViewController, context: UIViewControllerRepresentableContext<AddShortcutWrapper>) {}
    
    private class Delegate: NSObject, INUIAddVoiceShortcutViewControllerDelegate {
        func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
          controller.dismiss(animated: true, completion: nil)
        }
         
        func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
          controller.dismiss(animated: true, completion: nil)
        }
    }

}
