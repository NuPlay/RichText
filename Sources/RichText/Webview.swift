import SwiftUI

import WebKit

struct Webview : UIViewRepresentable {
    
    @Binding var dynamicHeight: CGFloat//뷰의 높이를 측정하기 위해서 사용
    private var webview: WKWebView = WKWebView()
    
    var html : String //들어갈 내용
    
    var lineHeight : CGFloat = 170
    var imageRadius : CGFloat = 0
    var fontType : fontType = .default
    
    var colorScheme : colorScheme = .automatic
    var colorImportant : Bool = false
    
    public init(dynamicHeight:Binding<CGFloat>, webview : WKWebView = WKWebView(), html: String, lineHeight : CGFloat = 170,imageRadius : CGFloat = 0, fontType: fontType = .default, colorScheme : colorScheme = .automatic, colorImportant : Bool = false) {
        self._dynamicHeight = dynamicHeight
        self.webview = webview
        
        self.html = html
        
        self.lineHeight = lineHeight
        self.imageRadius = imageRadius
        self.fontType = fontType
        
        self.colorScheme = colorScheme
        self.colorImportant = colorImportant
    }
    
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: Webview
        
        init(_ parent: Webview) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
                DispatchQueue.main.async {
                    self.parent.dynamicHeight = height as! CGFloat
                }
            })
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: Context) -> WKWebView  {
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        let htmlStart = """
            <HTML>
            <head>
                <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
            </head>
            """
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(css(colorScheme: self.colorScheme))\(html)\(htmlEnd)"
        webview.loadHTMLString(htmlString, baseURL:  nil)
        //웹뷰의 배경을 투명하게 만들어줌 (기본은 흰색으로 나와서 기존 UI랑 다르다는 느낌을 줌)
        webview.isOpaque = false
        webview.backgroundColor = UIColor.clear
        webview.scrollView.backgroundColor = UIColor.clear
        //
        return webview
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    func css(colorScheme: colorScheme) -> String {
        switch colorScheme {
        case .light:
            return """
            <style type='text/css'>
                img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote {text-align:left|right|center; line-height: \(lineHeight)%; font-family: '\(fontName(fontType: self.fontType))'; color: #000000 \(colorImportant == false ? "" : "!important"); }
                iframe{width:100%; height:250px;}
            
            </style>
            <BODY>
            """
        case .dark :
            return """
            <style type='text/css'>
                img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote {text-align:left|right|center; line-height: \(lineHeight)%; font-family: '\(fontName(fontType: self.fontType))'; color: #F2F2F2 \(colorImportant == false ? "" : "!important"); }
                iframe{width:100%; height:250px;}
            
            </style>
            <BODY>
            """
        case .automatic:
            return """
            <style type='text/css'>
            @media (prefers-color-scheme: light) {
                img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote {text-align:left|right|center; line-height: \(lineHeight)%; font-family: '\(fontName(fontType: self.fontType))'; color: #000000 \(colorImportant == false ? "" : "!important"); }
                iframe{width:100%; height:250px;}
            }
            @media (prefers-color-scheme: dark) {
                img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote {text-align:left|right|center; line-height: \(lineHeight)%; font-family: '\(fontName(fontType: self.fontType))'; color: #F2F2F2 \(colorImportant == false ? "" : "!important"); }
                iframe{width:100%; height:250px;}
            }
            </style>
            <BODY>
            """
        }
    }
    func fontName(fontType: fontType) -> String {
        switch fontType {
        case .default:
            return UIFont.systemFont(ofSize: 17, weight: .regular).fontName
        case .monospaced:
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
        case .italic:
            return UIFont.italicSystemFont(ofSize: 17).fontName
        }
    }
}
