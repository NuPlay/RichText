//
//  WebView.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI
import WebKit
import SafariServices

struct WebView {
    @Environment(\.multilineTextAlignment) var alignment
    @Binding var dynamicHeight: CGFloat

    let html: String
    let conf: Configuration
    let width: CGFloat
    
    init(width: CGFloat, dynamicHeight: Binding<CGFloat>, html: String, configuration: Configuration) {
        self._dynamicHeight = dynamicHeight
        
        self.html = html
        self.conf = configuration
        self.width = width
    }
}

#if canImport(UIKit)
import UIKit
extension WebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        webview.scrollView.isScrollEnabled = false
        
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            webview.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
        
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        DispatchQueue.main.async {
            uiView.frame.size = .init(width: width, height: dynamicHeight)
            
            let bundleURL = Bundle.main.bundleURL
            uiView.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#else
import AppKit
private class ScrollAdjustedWKWebView: WKWebView {
    override public func scrollWheel(with event: NSEvent) {
        nextResponder?.scrollWheel(with: event)
    }
}

extension WebView: NSViewRepresentable {
    func makeNSView(context: Context) -> WKWebView {
        let webview = ScrollAdjustedWKWebView()
        webview.navigationDelegate = context.coordinator
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            webview.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
        webview.setValue(false, forKey: "drawsBackground")

        return webview
    }

    func updateNSView(_ nsView: WKWebView, context _: Context) {
        DispatchQueue.main.async {
            let bundleURL = Bundle.main.bundleURL
            nsView.loadHTMLString(generateHTML(), baseURL: bundleURL)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#endif

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.getElementById(\"NuPlay_RichText\").offsetHeight", completionHandler: { (height, _) in
                DispatchQueue.main.async {
                    if let height = height as? CGFloat {
                        withAnimation(self.parent.conf.transition) {
                            self.parent.dynamicHeight = height
                        }
                    } else {
                        self.parent.dynamicHeight = 0
                    }
                }
            })
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard navigationAction.navigationType == WKNavigationType.linkActivated,
                  var url = navigationAction.request.url else {
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
            
            if url.scheme == nil {
                guard let httpsURL = URL(string: "https://\(url.absoluteString)") else { return }
                url = httpsURL
            }
            
            switch url.scheme {
            case "mailto", "tel":
                #if canImport(UIKit)
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                #else
                NSWorkspace.shared.open(url)
                #endif
            case "http", "https":
                switch parent.conf.linkOpenType {
                #if canImport(UIKit)
                case let .SFSafariView(conf, isReaderActivated, isAnimated):
                    if let reader = isReaderActivated {
                        conf.entersReaderIfAvailable = reader
                    }
                    let root = UIApplication.shared.windows.first?.rootViewController
                    root?.present(SFSafariViewController(url: url, configuration: conf), animated: isAnimated, completion: nil) #else
                #endif
                case .Safari:
                    #if canImport(UIKit)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    #else
                    NSWorkspace.shared.open(url)
                    #endif
                case .none:
                    break
                }
            default:
                #if canImport(UIKit)
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
                #else
                NSWorkspace.shared.open(url)
                #endif
            }

            decisionHandler(WKNavigationActionPolicy.cancel)
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
            <div id="NuPlay_RichText">\(html)</div>
            </BODY>
            </HTML>
            """
    }
    
    func generateCSS() -> String {
        switch conf.colorScheme {
        case .light:
            return """
            <style type='text/css'>
                \(conf.css(isLight: true, alignment: alignment))
                \(conf.customCSS)
                body {
                    margin: 0;
                    padding: 0;
                }
            </style>
            <BODY>
            """
        case .dark:
            return """
            <style type='text/css'>
                \(conf.css(isLight: false, alignment: alignment))
                \(conf.customCSS)
                body {
                    margin: 0;
                    padding: 0;
                }
            </style>
            <BODY>
            """
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
            body {
                margin: 0;
                padding: 0;
            }
            </style>
            <BODY>
            """
        }
    }
}
