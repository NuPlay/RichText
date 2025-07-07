//
//  SwiftUIWebView.swift
//  RichText
//
//  Created by Jesse Covington on 7/6/25.
//

import SwiftUI
import WebKit

@available(iOS 26, watchOS 26, visionOS 26, tvOS 26, macOS 26, *)
struct SwiftUIWebView: View {
    let html: String
    let conf: Configuration
    
    @State var webPage: WebPage
    
    init(html: String, conf: Configuration) {
        self.html = html
        self.conf = conf
        
        // load html into page
        self.webPage = WebPage()
        self.webPage.load(html: html, baseURL: conf.baseURL!)
    }
    
    var body: some View {
        WebView(webPage)
            .padding()
    }
}

@available(iOS 26, watchOS 26, visionOS 26, tvOS 26, macOS 26, *)
#Preview {
    SwiftUIWebView(
        html: "<h1>Hello World</h1><p>Hello!</p>",
        conf: .init()
    )
}
