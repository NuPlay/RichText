//
//  RichTextEnums.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import Foundation
import SafariServices

public enum FontType {
    case system
    case monospaced
    case italic
    #if canImport(UIKit)
    case custom(UIFont)
    #endif
    case customName(String)

    @available(*, deprecated, renamed: "system")
    case `default`
    
    var name: String {
        switch self {
        case .monospaced:
            #if canImport(UIKit)
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
            #else
            return NSFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
            #endif
        case .italic:
            #if canImport(UIKit)
            return UIFont.italicSystemFont(ofSize: 17).fontName
            #else
            return NSFont(descriptor: NSFont.systemFont(ofSize: 17).fontDescriptor.withSymbolicTraits(.italic), size: 17)?.fontName ?? ""
            #endif
        #if canImport(UIKit)
        case let .custom(font):
            return font.fontName
        #endif
        case let .customName(name):
            return name
        default:
            return "-apple-system"
        }
    }
}

public enum LinkOpenType {
    #if canImport(UIKit)
    case SFSafariView(configuration: SFSafariViewController.Configuration = .init(), isReaderActivated: Bool? = nil, isAnimated: Bool = true)
    #endif
    case Safari
    case none
}

public enum ColorPreference {
    case all
    case onlyLinks
    case none
}

public enum ColorScheme {
    case light
    case dark
    case auto
}

// MARK: - Deprected Enums
/*
@available(*, deprecated, renamed: "ColorScheme")
public enum colorScheme: String {
    case light = "light"
    case dark = "dark"
    case automatic = "automatic"
}

@available(*, deprecated, renamed: "FontType")
public enum fontType: String {
    case system = "system"
    case monospaced = "monospaced"
    case italic = "italic"

    @available(*, deprecated, renamed: "system")
    case `default` = "default"
}

@available(*, deprecated, renamed: "LinkOpenType")
public enum linkOpenType: String {
    case SFSafariView = "SFSafariView"
    case SFSafariViewWithReader = "SFSafariViewWithReader"
    case Safari = "Safari"
    case none = "none"
}
*/
