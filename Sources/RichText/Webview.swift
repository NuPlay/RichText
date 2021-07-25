import SwiftUI

import WebKit

struct Webview : UIViewRepresentable {
    
    
    @Binding var dynamicHeight: CGFloat//뷰의 높이를 측정하기 위해서 사용
    
    private var webview: WKWebView = WKWebView()
    
    var html : String //들어갈 내용
//    var fontSize : CGFloat = 17
    var lineHeight : CGFloat = 170
    var imageRadius : CGFloat = 0
    var colorScheme : colorScheme
    
    
    public init(dynamicHeight:Binding<CGFloat>, webview : WKWebView = WKWebView(), html: String/*,fontSize : CGFloat = 17*/, lineHeight : CGFloat = 170,imageRadius : CGFloat = 0, colorScheme : colorScheme) {
        self._dynamicHeight = dynamicHeight
        self.webview = webview
        self.html = html
//        self.fontSize = fontSize
        self.lineHeight = lineHeight
        self.imageRadius = imageRadius
        self.colorScheme = colorScheme
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
        let fontName = UIFont.systemFont(ofSize: 17.0).fontName
        
        webview.scrollView.bounces = false
        webview.navigationDelegate = context.coordinator
        let htmlStart = """
            <HTML>
            <head>
                <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'>
            </head>
            <style type='text/css'>
                img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
            h1, h2, h3, h4, h5, h6, p, dl, ol, ul, pre, blockquote {text-align:left|right|center; line-height: \(lineHeight)%; font-family: '\(fontName)'; color: \(colorScheme == .light ? "#000000" : "#F2F2F2") !important;"}
                iframe{width:100%; height:250px;}
            </style>
            <BODY>
            """
        let htmlEnd = "</BODY></HTML>"
        let htmlString = "\(htmlStart)\(html)\(htmlEnd)"
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
}
