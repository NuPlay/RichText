//
//  RichText.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import SwiftUI

public struct RichText: View {
    @State private var dynamicHeight: CGFloat = .zero
    
    let html: String
    var configuration: Configuration
    var placeholder: AnyView?
    
    public init(html: String, configuration: Configuration = .init(), placeholder: AnyView? = nil) {
        self.html = html
        self.configuration = configuration
        self.placeholder = placeholder
    }

    public var body: some View {
        GeometryReader{ proxy in
            ZStack(alignment: .top) {
                WebView(width: proxy.size.width, dynamicHeight: $dynamicHeight, html: html, configuration: configuration)

                if self.dynamicHeight == 0 {
                    placeholder
                }
            }
        }
        .frame(height: dynamicHeight)
    }
}

struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        RichText(html: "")
    }
}
