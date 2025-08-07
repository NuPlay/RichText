//
//  Configuration.swift
//  
//
//  Created by Macbookator on 5.06.2022.
//

import SwiftUI

public struct Configuration {
    
    public var customCSS: String
    
    public var supportsDynamicType: Bool
    
    public var fontType: FontType
    public var fontColor: ColorSet
    public var lineHeight: CGFloat
    
    public var colorScheme: ColorScheme
    public var forceColorSchemeBackground: Bool
    public var backgroundColor: String?
    
    public var imageRadius: CGFloat
    
    public var linkOpenType: LinkOpenType
    public var linkColor: ColorSet
    public var baseURL: URL?
    
    public var isColorsImportant: ColorPreference
    
    public var transition: Animation?
    

    public init(
        customCSS: String = "",
        supportsDynamicType: Bool = false,
        fontType: FontType = .system,
        fontColor: ColorSet = .init(light: "000000", dark: "F2F2F2"),
        lineHeight: CGFloat = 170,
        colorScheme: ColorScheme = .auto,
        forceColorSchemeBackground: Bool = false,
        backgroundColor: String? = nil,
        imageRadius: CGFloat = 0,
        linkOpenType: LinkOpenType = .Safari,
        linkColor: ColorSet = .init(light: "007AFF", dark: "0A84FF", isImportant: true),
        baseURL: URL? = Bundle.main.bundleURL,
        isColorsImportant: ColorPreference = .onlyLinks,
        transition: Animation? = .none
    ) {
        self.customCSS = customCSS
        self.supportsDynamicType = supportsDynamicType
        self.fontType = fontType
        self.fontColor = fontColor
        self.lineHeight = lineHeight
        self.colorScheme = colorScheme
        self.forceColorSchemeBackground = forceColorSchemeBackground
        self.backgroundColor = backgroundColor
        self.imageRadius = imageRadius
        self.linkOpenType = linkOpenType
        self.linkColor = linkColor
        self.baseURL = baseURL
        self.isColorsImportant = isColorsImportant
        self.transition = transition
        
        if supportsDynamicType {
            self.customCSS = self.customCSS + """
            html { font: -apple-system-body; }

            body { font: -apple-system-body; }

            h1 { font: -apple-system-largeTitle; }
            h2 { font: -apple-system-title1; }
            h3 { font: -apple-system-title2; }
            h4 { font: -apple-system-title3; }

            h5 { font: -apple-system-headline; }
            h6 { font: -apple-system-callout; }
            
            p.subheadline { font: -apple-system-subheadline; }
            p.footnote    { font: -apple-system-footnote; }
            p.caption1    { font: -apple-system-caption1; }
            p.caption2    { font: -apple-system-caption2; }
            """
        }
    }
    
    public init(backgroundColor: String?) {
        self.init(
            customCSS: "",
            supportsDynamicType: false,
            fontType: .system,
            fontColor: .init(light: "000000", dark: "F2F2F2"),
            lineHeight: 170,
            colorScheme: .auto,
            forceColorSchemeBackground: false,
            backgroundColor: backgroundColor,
            imageRadius: 0,
            linkOpenType: .Safari,
            linkColor: .init(light: "007AFF", dark: "0A84FF", isImportant: true),
            baseURL: Bundle.main.bundleURL,
            isColorsImportant: .onlyLinks,
            transition: .none
        )
    }
    
    private func backgroundColor(_ isLight: Bool) -> String {
        if let backgroundColor{
            return backgroundColor
        }else if isLight {
            return "white \(forceColorSchemeBackground ? "!important": "")"
        } else {
            return "black \(forceColorSchemeBackground ? "!important": "")"
        }
    }
    
    func css(isLight: Bool, alignment: TextAlignment) -> String {
        """
        img{max-height: 100%; min-height: 100%; height:auto; max-width: 100%; width:auto;margin-bottom:5px; border-radius: \(imageRadius)px;}
        h1, h2, h3, h4, h5, h6, p, div, dl, ol, ul, pre, blockquote {text-align:\(alignment.htmlDescription); line-height: \(lineHeight)%; font-family: '\(fontType.name)' !important; color: \(fontColor.value(isLight)); background-color: \(backgroundColor(isLight)); }
        iframe{width:100%; height:250px;}
        a:link {color: \(linkColor.value(isLight));}
        A {text-decoration: none;}
        """
    }
}

