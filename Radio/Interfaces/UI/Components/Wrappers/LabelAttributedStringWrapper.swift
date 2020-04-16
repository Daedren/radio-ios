import UIKit
import SwiftUI

struct TextWithAttributedString: UIViewRepresentable {
    @Binding var height: CGFloat
    var attributedString:NSMutableAttributedString
    
    func makeUIView(context: Context) -> UILabel {
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
//        label.autoresizesSubviews = true
//        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }
    
    func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<TextWithAttributedString>) {
        uiView.attributedText = attributedString
        
        DispatchQueue.main.async {
            self.height = uiView.sizeThatFits(UIScreen.main.bounds.size).height
        }

    }
}
