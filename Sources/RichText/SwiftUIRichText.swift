//
//  RichText.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI

@available(iOS 26, macOS 26, watchOS 26, tvOS 26, visionOS 26, *)
public struct SwiftUIRichText: View {
    @State private var dynamicHeight: CGFloat = .zero
    
    let html: String
    var configuration: SwiftUIConfiguration
    var placeholder: AnyView?
    
    public init(html: String, configuration: SwiftUIConfiguration = .init(), placeholder: AnyView? = nil) {
        self.html = html
        self.configuration = configuration
        self.placeholder = placeholder
    }

    public var body: some View {
        SwiftUIWebView(html: html, conf: configuration)
    }
}

@available(iOS 26, macOS 26, watchOS 26, tvOS 26, visionOS 26, *)
struct SwiftUIRichText_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIRichText(html: "<h1>Hello World</h1>")
    }
}
