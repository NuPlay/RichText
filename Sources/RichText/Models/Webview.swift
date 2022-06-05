//
//  Webview.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI
import WebKit
import SafariServices

struct Webview: UIViewRepresentable {
    @Binding var dynamicHeight: CGFloat

    let html: String
    let customCSS: String
    
    let lineHeight: CGFloat
    let imageRadius: CGFloat
    let fontType: FontType

    let colorScheme: ColorScheme
    let colorImportant: Bool

    let linkOpenType: LinkOpenType
    let linkColor: ColorSet
    let alignment: TextAlignment

    init(dynamicHeight: Binding<CGFloat>, html: String, customCSS: String, lineHeight: CGFloat,imageRadius: CGFloat, fontType: FontType, colorScheme: ColorScheme, colorImportant: Bool, linkOpenType: LinkOpenType, linkColor: ColorSet, alignment: TextAlignment) {
        self._dynamicHeight = dynamicHeight

        self.html = html
        self.customCSS = customCSS
        
        self.lineHeight = lineHeight
        self.imageRadius = imageRadius
        self.fontType = fontType

        self.colorScheme = colorScheme
        self.colorImportant = colorImportant

        self.linkOpenType = linkOpenType
        self.linkColor = linkColor
        self.alignment = alignment
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

extension Webview {
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview

        init(_ parent: Webview) {
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
                    switch self.parent.linkOpenType {
                    case .SFSafariView(let conf, let isAnimated):
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

extension Webview {
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
        switch colorScheme {
        case .light:
            return "<style type='text/css'>\(css(isLight: true))\(customCSS)</style><BODY>"
        case .dark :
            return "<style type='text/css'>\(css(isLight: false))\(customCSS)</style><BODY>"
        case .automatic:
            return """
            <style type='text/css'>
            @media (prefers-color-scheme: light) {
                \(css(isLight: true))
            }
            @media (prefers-color-scheme: dark) {
                \(css(isLight: false))
            }
            \(customCSS)
            </style>
            <BODY>
            """
        }
    }
    
    func css(isLight: Bool) -> String {
        """
        img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
        h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontType.name)' !important; color: #\(isLight ? "000000" : "F2F2F2") \(colorImportant == false ? "" : "!important"); }
        iframe{width:100%; height:250px;}
        a:link {color: \(isLight ? linkColor.light : linkColor.dark);}
        A {text-decoration: none;}
        """
    }
}
