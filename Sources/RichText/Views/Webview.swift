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
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(
            context.coordinator, 
            name: RichTextConstants.heightNotificationHandler
        )
        configuration.userContentController.add(
            context.coordinator,
            name: RichTextConstants.mediaClickHandler
        )
        let webview = WKWebView(frame: .zero, configuration: configuration)
        
        // Configure scrolling behavior
        webview.scrollView.bounces = false
        webview.scrollView.isScrollEnabled = false
        
        // Set delegates
        webview.navigationDelegate = context.coordinator
        
        // Configure appearance
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        
        // Load HTML content
        loadHTML(in: webview)
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadHTML(in: uiView)
        DispatchQueue.main.async { [weak uiView] in
            guard let webview = uiView else { return }
            webview.frame.size = .init(width: self.width, height: self.dynamicHeight)
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
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.add(
            context.coordinator, 
            name: RichTextConstants.heightNotificationHandler
        )
        configuration.userContentController.add(
            context.coordinator,
            name: RichTextConstants.mediaClickHandler
        )
        let webview = ScrollAdjustedWKWebView(frame: .zero, configuration: configuration)
        
        // Set delegate
        webview.navigationDelegate = context.coordinator
        
        // Configure appearance
        webview.setValue(false, forKey: "drawsBackground")
        
        // Load HTML content
        loadHTML(in: webview)

        return webview
    }

    func updateNSView(_ nsView: WKWebView, context _: Context) {
        loadHTML(in: nsView)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#endif

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            handleNavigationError(error)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            handleNavigationError(error)
        }
        
        private func handleNavigationError(_ error: Error) {
            DispatchQueue.main.async {
                self.parent.conf.errorHandler?(.htmlLoadingFailed("\(error.localizedDescription): \(self.parent.html.prefix(100))"))
            }
        }
                

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == RichTextConstants.heightNotificationHandler {
                if let height = message.body as? NSNumber {
                    let cgFloatHeight = CGFloat(height.doubleValue)
                    DispatchQueue.main.async {
                        withAnimation(self.parent.conf.transition) {
                            self.parent.dynamicHeight = cgFloatHeight
                        }
                    }
                }
            } else if message.name == RichTextConstants.mediaClickHandler {
                if let messageBody = message.body as? [String: Any],
                   let type = messageBody["type"] as? String,
                   let src = messageBody["src"] as? String {
                    
                    DispatchQueue.main.async {
                        switch type {
                        case "image":
                            self.parent.conf.mediaClickHandler?(.image(src: src))
                        case "video":
                            self.parent.conf.mediaClickHandler?(.video(src: src))
                        default:
                            self.parent.conf.errorHandler?(.mediaHandlingFailed("Unknown media type: \(type)"))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.parent.conf.errorHandler?(.mediaHandlingFailed("Invalid media message"))
                    }
                }
            }
        }
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard navigationAction.navigationType == WKNavigationType.linkActivated,
                  var url = navigationAction.request.url else {
                decisionHandler(WKNavigationActionPolicy.allow)
                return
            }
            
            if case let .custom(action) = parent.conf.linkOpenType {
                action(url)
            } else {
                if url.scheme == nil {
                    guard let httpsURL = URL(string: "https://\(url.absoluteString)") else {
                        decisionHandler(WKNavigationActionPolicy.cancel)
                        return
                    }
                    url = httpsURL
                }
                
                switch url.scheme {
                case RichTextConstants.mailtoScheme, RichTextConstants.telScheme:
                    #if canImport(UIKit)
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    #else
                    NSWorkspace.shared.open(url)
                    #endif
                case RichTextConstants.httpScheme, RichTextConstants.httpsScheme:
                    switch parent.conf.linkOpenType {
                        #if canImport(UIKit)
                    case let .SFSafariView(conf, isReaderActivated, isAnimated):
                        if let reader = isReaderActivated {
                            conf.entersReaderIfAvailable = reader
                        }
                        let root = UIApplication.shared.windows.first?.rootViewController
                        root?.present(SFSafariViewController(url: url, configuration: conf), animated: isAnimated, completion: nil)
                        #endif
                    case .Safari:
                        #if canImport(UIKit)
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        #else
                        NSWorkspace.shared.open(url)
                        #endif
                    case .none, .custom:
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
            }
            
            decisionHandler(WKNavigationActionPolicy.cancel)
        }
    }
}

extension WebView {
    /// Loads HTML content into the WebView safely on main thread
    /// - Parameter webView: The WKWebView instance to load content into
    private func loadHTML(in webView: WKWebView) {
        DispatchQueue.main.async { [weak webView] in
            guard let webView = webView else { return }
            webView.loadHTMLString(self.generateHTML(), baseURL: self.conf.baseURL)
        }
    }
    
    /// Generates the complete HTML string for the WebView
    /// - Returns: Complete HTML document string
    func generateHTML() -> String {
        return String(
            format: RichTextConstants.htmlTemplate,
            generateCSS(),
            RichTextConstants.richTextContainerID,
            html,
            RichTextConstants.heightNotificationHandler,
            RichTextConstants.richTextContainerID,
            RichTextConstants.mediaClickHandler,
            RichTextConstants.mediaClickHandler
        )
    }
    
    /// Generates CSS styles based on color scheme configuration
    /// - Returns: CSS string wrapped in style tags
    func generateCSS() -> String {
        switch conf.colorScheme {
        case .light:
            return String(
                format: RichTextConstants.cssTemplate,
                conf.css(isLight: true, alignment: alignment),
                conf.customCSS
            )
        case .dark:
            return String(
                format: RichTextConstants.cssTemplate,
                conf.css(isLight: false, alignment: alignment),
                conf.customCSS
            )
        case .auto:
            return String(
                format: RichTextConstants.mediaCSSTemplate,
                conf.css(isLight: true, alignment: alignment),
                conf.css(isLight: false, alignment: alignment),
                conf.customCSS
            )
        }
    }
}
