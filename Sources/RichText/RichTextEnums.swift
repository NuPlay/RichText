//
//  SwiftUIView.swift
//
//
//  Created by 이웅재 on 2021/07/26.
//

import Foundation

public enum colorScheme: String {
    case light = "light"
    case dark = "dark"
    case automatic = "automatic"
}

public enum fontType : String {
    case system = "system"
    case monospaced = "monospaced"
    case italic = "italic"
    
    @available(*, deprecated, renamed: "system")
    case `default` = "default"
}

public enum linkOpenType: String {
    case SFSafariView = "SFSafariView"
    case SFSafariViewWithReader = "SFSafariViewWithReader"
    case Safari = "Safari"
    case none = "none"
}
