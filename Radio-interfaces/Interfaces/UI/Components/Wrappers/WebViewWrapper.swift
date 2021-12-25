import SwiftUI
import WebKit

@available(iOS 13.0, *)
public struct WebView : UIViewRepresentable {
    
    var request: URLRequest? = nil
    var html: String? = nil
    var delegate: WebViewDelegate
    let application: UIApplication
    
    public init(application: UIApplication, html: String = "") {
        self.application = application
        self.html = html
        self.delegate = WebViewDelegate(application: application)
    }
    
    public func makeUIView(context: Context) -> WKWebView  {
        let uiView = WKWebView()
        uiView.isOpaque = false
        uiView.backgroundColor = .clear
        uiView.scrollView.backgroundColor = .clear
        uiView.navigationDelegate = self.delegate
        self.injectHTML(webview: uiView, url: self.html ?? "")
        return uiView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        self.injectHTML(webview: uiView, url: self.html ?? "")
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public class Coordinator: NSObject, WKNavigationDelegate {
        var webView: WebView
        init(_ webView: WebView) {
            self.webView = webView
        }
    }
    
    private func injectHTML(webview: WKWebView, url: String) {
            webview.loadHTMLString("""
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
                <a href="\(url)">Thread up!</a></h1></html>
                </body>
                """
                                  , baseURL: nil)
    }
    
}

@available(iOS 13.0, *)
class WebViewDelegate: NSObject, WKNavigationDelegate {
    let application: UIApplication
    init(application: UIApplication) {
        self.application = application
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
               let host = url.host, !host.hasPrefix("r-a-d.io"),
               self.application.canOpenURL(url) {
                self.application.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
}
