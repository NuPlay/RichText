//
//  SwiftUIWebView.swift
//  RichText
//
//  Created by Jesse Covington on 7/6/25.
//

import SwiftUI
import WebKit

let testHTML = """
    <body>
      <h1>Lorem Ipsum</h1>
      <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor.</p>
      <p>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat.</p>
      <p>Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus. Phasellus ultrices nulla quis nibh. Quisque a lectus.</p>
      
      <h2>Section One</h2>
      <p>Donec consectetuer ligula vulputate sem tristique cursus. Nam nulla quam, gravida non, commodo a, sodales sit amet, nisi.</p>
      <p>Pellentesque fermentum dolor. Aliquam quam lectus, facilisis auctor, ultrices ut, elementum vulputate, nunc.</p>
      <p>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu.</p>
      
      <h2>Section Two</h2>
      <p>Cras consequat. Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat.</p>
      <p>Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsan porttitor, facilisis luctus, metus.</p>
      <p>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu.</p>
      <p>Aliquam tincidunt mauris eu risus. Vestibulum auctor dapibus neque. Nunc dignissim risus id metus.</p>

      <h2>Section Three</h2>
      <p>Ut convallis, sem sit amet interdum consectetuer, odio augue aliquam leo, nec dapibus tortor nibh sed augue.</p>
      <p>Integer eu magna sit amet metus fermentum posuere. Morbi sit amet nulla sed dolor elementum imperdiet.</p>
      <p>Duis arcu tortor, suscipit eget, imperdiet nec, imperdiet iaculis, ipsum. Sed aliquam ultrices mauris.</p>
      <p>Integer ante arcu, accumsan a, consectetuer eget, posuere ut, mauris. Praesent adipiscing.</p>

      <h2>Section Four</h2>
      <p>Vestibulum eu odio. Vivamus laoreet. Nullam tincidunt adipiscing enim. Phasellus tempus. Proin viverra, ligula sit amet ultrices semper, ligula arcu tristique sapien.</p>
      <p>Ut convallis, sem sit amet interdum consectetuer, odio augue aliquam leo, nec dapibus tortor nibh sed augue.</p>
      <p>Sed hendrerit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.</p>
      <p>Ut non enim eleifend felis pretium feugiat. Vivamus quis mi. Phasellus a est.</p>
      <p>Phasellus magna. In hac habitasse platea dictumst. Curabitur at lacus ac velit ornare lobortis.</p>
      <p>Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.</p>
    </body>
    """

@available(iOS 26, watchOS 26, visionOS 26, tvOS 26, macOS 26, *)
struct SwiftUIWebView: View {
    let html: String
    let conf: SwiftUIConfiguration
    
    @State var webPage: WebPage
    
    init(html: String, conf: SwiftUIConfiguration) {
        self.html = html
        self.conf = conf
        
        // load html into page
        self.webPage = WebPage()
        self.webPage.load(html: self.generateHTML(), baseURL: conf.baseURL!)
    }
    
    private func generateHTML() -> String {
        return """
            <head>
                <meta name="viewport" content="width=device-width, initial‑scale=1.0, maximum‑scale=1.0, minimum‑scale=1.0, user‑scalable=no">
            </head>
            <style>
                \(self.generateCSS())
            </style>
            \(html)
            """
    }
    
    private func generateCSS() -> String {
        let fontName: String
        switch self.conf.fontType {
        case .system:
            fontName = "system-ui"
        case .monospaced:
            fontName = "ui-monospace"
        case .serif:
            fontName = "ui-serif"
        case .customName:
            fontName = self.conf.fontType.name
        default:
            fontName = ""
        }
        
        return """
            * {
                font-family: \(fontName);
            }
            
            \(conf.customCSS)
            """
    }
    
    var body: some View {
        WebView(webPage)
            .padding()
    }
}

@available(iOS 26, watchOS 26, visionOS 26, tvOS 26, macOS 26, *)
#Preview {
    SwiftUIWebView(
        html: testHTML,
        conf: SwiftUIConfiguration(
            customCSS: "h1 {color: red;}",
            fontType: .serif
        )
    )
}
