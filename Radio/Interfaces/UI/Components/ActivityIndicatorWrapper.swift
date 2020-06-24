import UIKit
import SwiftUI

struct ActivityIndicatorWrapper: UIViewRepresentable {
    let style: UIActivityIndicatorView.Style

    func makeUIView(context: UIViewRepresentableContext<ActivityIndicatorWrapper>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = UIColor.white
        return indicator
    }

    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicatorWrapper>) {
        uiView.startAnimating()
    }
}
