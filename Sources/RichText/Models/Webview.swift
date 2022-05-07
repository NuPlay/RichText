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
    private var webview: WKWebView = WKWebView()

    let html: String
    let customCSS: String
    
    let lineHeight: CGFloat
    let imageRadius: CGFloat
    let fontType: fontType

    let colorScheme: colorScheme
    let colorImportant: Bool

    let linkOpenType: linkOpenType
    let linkColor: ColorSet
    let alignment: TextAlignment

    init(dynamicHeight: Binding<CGFloat>, webview: WKWebView = WKWebView(), html: String, customCSS: String, lineHeight: CGFloat,imageRadius: CGFloat, fontType: fontType, colorScheme: colorScheme, colorImportant: Bool, linkOpenType: linkOpenType, linkColor: ColorSet, alignment: TextAlignment) {
        self._dynamicHeight = dynamicHeight
        self.webview = webview

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
    
    static func dismantleUIView(_ uiView: UIScrollView, coordinator: Coordinator) {
        uiView.delegate = nil
        coordinator.parent.webview.stopLoading()
        coordinator.parent.webview.navigationDelegate = nil
        coordinator.parent.webview.scrollView.delegate = nil
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
        let light = """
            img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontName)' !important; color: #000000 \(colorImportant == false ? "" : "!important"); }
            iframe{width:100%; height:250px;}
            a:link {color: \(linkColor.light);}
            A {text-decoration: none;}
            """
        
        let dark = """
            img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontName)' !important; color: #F2F2F2 \(colorImportant == false ? "" : "!important"); }
            iframe{width:100%; height:250px;}
            a:link {color: \(linkColor.dark);}
            A {text-decoration: none;}
            """
        
        switch colorScheme {
        case .light:
            return "<style type='text/css'>\(light)\(customCSS)</style><BODY>"
        case .dark :
            return "<style type='text/css'>\(dark)\(customCSS)</style><BODY>"
        case .automatic:
            return """
            <style type='text/css'>
            @media (prefers-color-scheme: light) {
                \(light)
            }
            @media (prefers-color-scheme: dark) {
                \(dark)
            }
            \(customCSS)
            </style>
            <BODY>
            """
        }
    }

    var fontName: String {
        switch fontType {
        case .monospaced:
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
        case .italic:
            return UIFont.italicSystemFont(ofSize: 17).fontName
        default:
            return "-apple-system"
        }
    }
}
