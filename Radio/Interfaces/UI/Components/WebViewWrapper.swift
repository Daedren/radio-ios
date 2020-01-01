import SwiftUI
import WebKit
  
struct WebView : UIViewRepresentable {
      
    var request: URLRequest? = nil
    var html: String? = nil
    var delegate: WebViewDelegate = WebViewDelegate()

    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
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
                <header>
                <meta name="viewport" content="width=device-width" />
                </header>
                <body>
                <a style="color:teal;
                text-align: center;
                display: block;
                font-size: 3rem;
                font-family: -apple-system, system-ui, BlinkMacSystemFont;" href="\(html)">Thread up!</a></h1>!--></html>
                </body>
"""
                , baseURL: nil)
            
//            var scriptContent = "var meta = document.createElement('meta');"
//            scriptContent += "meta.name='viewport';"
//            scriptContent += "meta.content='width=device-width';"
//            scriptContent += "document.getElementsByTagName('head')[0].appendChild(meta);"
//
//            uiView.evaluateJavaScript(scriptContent, completionHandler: nil)
        }
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
