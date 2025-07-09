//
//  Configuration.swift
//  
//
//  Created by Macbookator on 5.06.2022.
//

import SwiftUI

public enum RichTextFont {
    case serif
    case monospaced
    case system
    case italic
}

public struct SwiftUIConfiguration {
    public var customCSS: String
    public var customJavaScript: String
    public var fontType: RichTextFont
    public var baseURL: URL
    
    public init(
        customCSS: String = "",
        customJavaScript: String = "",
        fontType: RichTextFont = .system,
        baseURL: URL = URL(string: Bundle.main.bundlePath)!
    ) {
        self.customCSS = customCSS
        self.customJavaScript = customJavaScript
        self.fontType = fontType
        self.baseURL = baseURL
    }
}
