//
//  Configuration.swift
//  
//
//  Created by Macbookator on 5.06.2022.
//

import SwiftUI

struct Configuration {
    var customCSS: String = ""
    
    var fontType: FontType = .system
    var fontColor: ColorSet = .init(light: "000000", dark: "F2F2F2")
    var lineHeight: CGFloat = 170
    
    var colorScheme: ColorScheme = .auto
    
    var imageRadius: CGFloat = 0
    
    var linkOpenType: LinkOpenType = .SFSafariView()
    var linkColor: ColorSet = .init(light: "007AFF", dark: "0A84FF", isImportant: true)
    
    var isColorsImportant: ColorPreference = .onlyLinks
    
    func css(isLight: Bool, alignment: TextAlignment) -> String {
        """
        img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
        h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontType.name)' !important; color: \(fontColor.value(isLight)); }
        iframe{width:100%; height:250px;}
        a:link {color: \(linkColor.value(isLight));}
        A {text-decoration: none;}
        """
    }
}
