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
    case `default` = "default"
    case monospaced = "monospaced"
    case italic = "italic"
}

public enum linkOpenType: String {
    case SFSafariView = "SFSafariView"
    case Safari = "Safari"
    case none = "none"
}
