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
    case custom(UIFont)
    case customName(String)

    @available(*, deprecated, renamed: "system")
    case `default`
    
    var name: String {
        switch self {
        case .monospaced:
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
        case .italic:
            return UIFont.italicSystemFont(ofSize: 17).fontName
        case .custom(let font):
            return font.fontName
        case .customName(let name):
            return name
        default:
            return "-apple-system"
        }
    }
}

public enum LinkOpenType {
    case SFSafariView(configuration: SFSafariViewController.Configuration = .init(), isReaderActivated: Bool? = nil, isAnimated: Bool = true)
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
