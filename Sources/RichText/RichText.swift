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

    var lineHeight: CGFloat = 170
    var imageRadius: CGFloat = 0
    var fontType: fontType = .system

    var colorScheme: colorScheme = .automatic
    var colorImportant: Bool = false

    var placeholder: AnyView?

    var linkOpenType: linkOpenType = .SFSafariView
    var linkColor: ColorSet = ColorSet(light: "#007AFF", dark: "#0A84FF")

    public init(html: String) {
        self.html = html
    }

    public var body: some View {
        ZStack(alignment: .top) {
            Webview(dynamicHeight: $dynamicHeight, html: html, lineHeight: lineHeight, imageRadius: imageRadius, fontType: fontType, colorScheme: colorScheme, colorImportant: colorImportant, linkOpenType: linkOpenType, linkColor: linkColor)
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
