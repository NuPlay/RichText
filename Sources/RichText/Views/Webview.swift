//
//  WebView.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI
import WebKit
import SafariServices

struct WebView: UIViewRepresentable {
    @Environment(\.multilineTextAlignment) var alignment
    @Binding var dynamicHeight: CGFloat

    let html: String
    let conf: Configuration

    init(dynamicHeight: Binding<CGFloat>, html: String, configuration: Configuration) {
        self._dynamicHeight = dynamicHeight

        self.html = html
        self.conf = configuration
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webview.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            webview.loadHTMLString(generateHTML(), baseURL: nil)
        }
        
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            uiView.loadHTMLString(generateHTML(), baseURL: nil)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, _) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }

        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == WKNavigationType.linkActivated {
                if let url = navigationAction.request.url {
                    let root = UIApplication.shared.windows.first?.rootViewController
                    switch self.parent.conf.linkOpenType {
                    case .SFSafariView(let conf, let isReaderActivated, let isAnimated):
                        if let reader = isReaderActivated {
                            conf.entersReaderIfAvailable = reader
                        }
                        root?.present(SFSafariViewController(url: url, configuration: conf), animated: isAnimated, completion: nil)
                    case .Safari:
                        UIApplication.shared.open(url)
                    case .none:
                        print("WebView Content Link: \(url)")
                    }
                }

                decisionHandler(WKNavigationActionPolicy.cancel)
                return
            }
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    }
}

extension WebView {
    func generateHTML() -> String {
        return """
            <HTML>
            <head>
                <meta name='viewport' content='width=device-width, shrink-to-fit=YES, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
            </head>
            \(generateCSS())
            <div>\(html)</div>
            </BODY>
            </HTML>
            """
    }
    
    func generateCSS() -> String {
        switch conf.colorScheme {
        case .light:
            return "<style type='text/css'>\(conf.css(isLight: true, alignment: alignment))\(conf.customCSS)</style><BODY>"
        case .dark:
            return "<style type='text/css'>\(conf.css(isLight: false, alignment: alignment))\(conf.customCSS)</style><BODY>"
        case .auto:
            return """
            <style type='text/css'>
            @media (prefers-color-scheme: light) {
                \(conf.css(isLight: true, alignment: alignment))
            }
            @media (prefers-color-scheme: dark) {
                \(conf.css(isLight: false, alignment: alignment))
            }
            \(conf.customCSS)
            </style>
            <BODY>
            """
        }
    }
}
