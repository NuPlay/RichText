//
//  RichTextEnums.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import Foundation
import SafariServices

public enum FontType: String {
    case system = "system"
    case monospaced = "monospaced"
    case italic = "italic"

    @available(*, deprecated, renamed: "system")
    case `default` = "default"
    
    var name: String {
        switch self {
        case .monospaced:
            return UIFont.monospacedSystemFont(ofSize: 17, weight: .regular).fontName
        case .italic:
            return UIFont.italicSystemFont(ofSize: 17).fontName
        default:
            return "-apple-system"
        }
    }
}

public enum LinkOpenType {
    case SFSafariView(configuration: SFSafariViewController.Configuration = .init(), isReaderActivated: Bool = false, isAnimated: Bool = true)
    case Safari
    case none
}

public enum ColorPreference {
    case all
    case onlyLinks
    case none
}
