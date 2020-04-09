import SwiftUI
import WebKit
  
struct WebView : UIViewRepresentable {
      
    var request: URLRequest? = nil
    var html: String? = nil
    var delegate: WebViewDelegate = WebViewDelegate()

    func makeUIView(context: Context) -> WKWebView  {
        let uiView = WKWebView()
        uiView.isOpaque = false
        uiView.backgroundColor = .clear
        uiView.scrollView.backgroundColor = .clear
        if let request = request {
            uiView.load(request)
        }
        if let html = html {
            uiView.navigationDelegate = self.delegate
            uiView.loadHTMLString("""
                <!DOCTYPE html>
                <html>
                <head>
                <meta name="viewport" content="width=device-width" />
                <style>
                html {
                font-size: 1.5em;
                }
                a {
                color:teal;
                text-align: center;
                display: block;
                font-family: -apple-system, system-ui, BlinkMacSystemFont;
                }
                </style>
                </head>
                <body>
                <a href="\(html)">Thread up!</a></h1>!--></html>
                </body>
                """
                , baseURL: nil)
    }
        return uiView
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {

    }
      
}

class WebViewDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("r-a-d.io"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }

}
