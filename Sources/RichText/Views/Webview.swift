//
//  WebView.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI
import WebKit
import os.log

// `SFSafariViewController` is UIKit-only, and SafariServices does not exist at all on some
// platforms (tvOS), where importing it unconditionally fails to compile.
#if canImport(UIKit) && canImport(SafariServices)
import SafariServices
#endif

/// Logger for WebView performance monitoring
private let webViewLogger = Logger(subsystem: "com.nuplay.richtext", category: "WebView")

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
        loadHTMLIfNeeded(in: webview, coordinator: context.coordinator)
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.parent = self
        loadHTMLIfNeeded(in: uiView, coordinator: context.coordinator)
        
        // Update frame directly without timer to avoid state modification during view update
        uiView.frame.size = .init(width: self.width, height: self.dynamicHeight)
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
        
        // Configure appearance.
        //
        // `drawsBackground` is not part of WKWebView's public API, it is reached through KVC.
        // `setValue(_:forKey:)` raises NSUnknownKeyException if the key ever goes away, and
        // that is an Objective-C exception Swift cannot catch, so it would take the host app
        // down. Probe for the setter and report a configuration failure instead.
        if webview.responds(to: NSSelectorFromString("setDrawsBackground:")) {
            webview.setValue(false, forKey: "drawsBackground")
        } else {
            webViewLogger.error("WKWebView no longer exposes drawsBackground; background will not be transparent")
            conf.errorHandler?(.webViewConfigurationFailed)
        }
        
        // Load HTML content
        loadHTMLIfNeeded(in: webview, coordinator: context.coordinator)

        return webview
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        context.coordinator.parent = self
        loadHTMLIfNeeded(in: nsView, coordinator: context.coordinator)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
#endif

extension WebView {
    class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        var parent: WebView

        /// The document that is currently loaded in the web view.
        ///
        /// SwiftUI calls `updateUIView`/`updateNSView` on every state change, including the
        /// dynamic height updates this view produces itself. Reloading the document each time
        /// threw away all in-page state (open `<details>`, playing media, scroll position) and
        /// re-paid the full parse and layout cost, so the content could never settle.
        var loadedHTML: String?

        /// The base URL the current document was loaded with.
        ///
        /// Tracked alongside the HTML because `loadHTMLString(_:baseURL:)` resolves relative
        /// resources against it. Changing `baseURL` while leaving the HTML untouched has to
        /// force a reload, otherwise relative URLs would keep resolving against the old base.
        var loadedBaseURL: URL?
        
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
            webViewLogger.error("Navigation error: \(error.localizedDescription)")

            // Drop the cached document so the next update retries the load. Without this the
            // guard in `loadHTMLIfNeeded` would keep matching the document that failed and the
            // web view would stay blank forever, whereas the previous unconditional reload
            // recovered on the next SwiftUI update.
            loadedHTML = nil
            loadedBaseURL = nil

            Task { @MainActor in
                self.parent.conf.errorHandler?(.htmlLoadingFailed("\(error.localizedDescription): \(self.parent.html.prefix(100))"))
            }
        }
                

        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            Task { @MainActor in
                await handleScriptMessage(message)
            }
        }
        
        @MainActor
        private func handleScriptMessage(_ message: WKScriptMessage) async {
            switch message.name {
            case RichTextConstants.heightNotificationHandler:
                await handleHeightUpdate(message.body)
                
            case RichTextConstants.mediaClickHandler:
                await handleMediaClick(message.body)
                
            default:
                webViewLogger.warning("Unknown script message: \(message.name)")
            }
        }
        
        @MainActor
        private func handleHeightUpdate(_ body: Any) async {
            guard let height = body as? NSNumber else {
                webViewLogger.error("Invalid height value received")
                return
            }
            
            let cgFloatHeight = CGFloat(height.doubleValue)
            
            // Only update if height actually changed to avoid unnecessary animations
            guard cgFloatHeight != self.parent.dynamicHeight else { return }
            
            // Defer the state update to avoid modifying state during view update
            DispatchQueue.main.async {
                withAnimation(self.parent.conf.transition) {
                    self.parent.dynamicHeight = cgFloatHeight
                }
            }
            
            webViewLogger.debug("Height updated to: \(cgFloatHeight)")
        }
        
        @MainActor
        private func handleMediaClick(_ body: Any) async {
            guard let messageBody = body as? [String: Any],
                  let type = messageBody["type"] as? String,
                  let src = messageBody["src"] as? String else {
                self.parent.conf.errorHandler?(.mediaHandlingFailed("Invalid media message"))
                return
            }
            
            switch type {
            case "image":
                self.parent.conf.mediaClickHandler?(.image(src: src))
            case "video":
                self.parent.conf.mediaClickHandler?(.video(src: src))
            default:
                self.parent.conf.errorHandler?(.mediaHandlingFailed("Unknown media type: \(type)"))
            }
        }
        @MainActor
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor @Sendable (WKNavigationActionPolicy) -> Void) {
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
                        #if canImport(UIKit) && canImport(SafariServices)
                    case let .SFSafariView(conf, isReaderActivated, isAnimated):
                        if let reader = isReaderActivated {
                            conf.entersReaderIfAvailable = reader
                        }
                        let root = UIApplication.shared.connectedScenes
                            .compactMap { $0 as? UIWindowScene }
                            .flatMap(\.windows)
                            .first { $0.isKeyWindow }?
                            .rootViewController
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
    /// Loads HTML content into the WebView safely on main thread, skipping redundant reloads
    /// - Parameters:
    ///   - webView: The WKWebView instance to load content into
    ///   - coordinator: The coordinator that tracks the currently loaded document
    @MainActor
    private func loadHTMLIfNeeded(in webView: WKWebView, coordinator: Coordinator) {
        let htmlString = generateHTML()
        let baseURL = conf.baseURL
        
        guard coordinator.loadedHTML != htmlString || coordinator.loadedBaseURL != baseURL else {
            webViewLogger.debug("Skipping reload, generated HTML and base URL are unchanged")
            return
        }
        
        // A malformed hex value is not rejected anywhere: it reaches the stylesheet as
        // `color: #whatever`, and the browser drops that declaration along with the rest of
        // the rule. The text or link colour then silently falls back to the default, which is
        // very hard to trace from the outside, so surface it.
        if !conf.fontColor.isValid || !conf.linkColor.isValid {
            webViewLogger.error("Invalid hex colour in fontColor or linkColor; the declaration will be dropped by the browser")
            conf.errorHandler?(.cssGenerationFailed)
        }
        
        coordinator.loadedHTML = htmlString
        coordinator.loadedBaseURL = baseURL
        
        webViewLogger.debug("Loading HTML content (\(htmlString.count) characters)")
        
        webView.loadHTMLString(htmlString, baseURL: baseURL)
    }
    
    /// Generates the complete HTML string for the WebView
    /// - Returns: Complete HTML document string
    func generateHTML() -> String {
        return RichTextConstants.htmlDocument(css: generateCSS(), body: html)
    }
    
    /// Generates CSS styles based on color scheme configuration
    /// - Returns: CSS string wrapped in style tags
    func generateCSS() -> String {
        switch conf.colorScheme {
        case .light:
            return RichTextConstants.styleDocument(
                css: conf.css(isLight: true, alignment: alignment),
                customCSS: conf.resolvedCustomCSS
            )
        case .dark:
            return RichTextConstants.styleDocument(
                css: conf.css(isLight: false, alignment: alignment),
                customCSS: conf.resolvedCustomCSS
            )
        case .auto:
            return RichTextConstants.styleDocument(
                lightCSS: conf.css(isLight: true, alignment: alignment),
                darkCSS: conf.css(isLight: false, alignment: alignment),
                customCSS: conf.resolvedCustomCSS
            )
        }
    }
}
