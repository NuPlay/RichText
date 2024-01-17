//
//  Configuration.swift
//  
//
//  Created by Macbookator on 5.06.2022.
//

import SwiftUI

public struct Configuration {
    
    public var customCSS: String
    
    public var fontType: FontType
    public var fontColor: ColorSet
    public var lineHeight: CGFloat
    
    public var colorScheme: ColorScheme
    
    public var imageRadius: CGFloat
    
    public var linkOpenType: LinkOpenType
    public var linkColor: ColorSet
    
    public var isColorsImportant: ColorPreference
    
    public var transition: Animation?
    
    public init(
        customCSS: String = "",
        fontType: FontType = .system,
        fontColor: ColorSet = .init(light: "000000", dark: "F2F2F2"),
        lineHeight: CGFloat = 170,
        colorScheme: ColorScheme = .auto,
        imageRadius: CGFloat = 0,
        linkOpenType: LinkOpenType = .Safari,
        linkColor: ColorSet = .init(light: "007AFF", dark: "0A84FF", isImportant: true),
        isColorsImportant: ColorPreference = .onlyLinks,
        transition: Animation? = .none
    ) {
        self.customCSS = customCSS
        self.fontType = fontType
        self.fontColor = fontColor
        self.lineHeight = lineHeight
        self.colorScheme = colorScheme
        self.imageRadius = imageRadius
        self.linkOpenType = linkOpenType
        self.linkColor = linkColor
        self.isColorsImportant = isColorsImportant
        self.transition = transition
    }
    
    public func css(isLight: Bool, alignment: TextAlignment) -> String {
        """
        img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
        h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontType.name)' !important; color: \(fontColor.value(isLight)); }
        iframe{width:100%; height:250px;}
        a:link {color: \(linkColor.value(isLight));}
        A {text-decoration: none;}
        """
    }
}
