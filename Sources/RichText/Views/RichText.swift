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
    var configuration: Configuration = .init()
    
    var placeholder: AnyView?
    
    public init(html: String) {
        self.html = html
    }

    public var body: some View {
        ZStack(alignment: .top) {
            WebView(dynamicHeight: $dynamicHeight, html: html, configuration: configuration)
                .frame(height: dynamicHeight)

            if self.dynamicHeight == 0 {
                placeholder
            }
        }
    }
}

struct RichText_Previews: PreviewProvider {
    static var previews: some View {
        RichText(html: "")
    }
}
