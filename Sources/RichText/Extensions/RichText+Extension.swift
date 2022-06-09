//
//  RichTextExtension.swift
//  
//
//  Created by 이웅재(NuPlay) on 2021/08/27.
//  https://github.com/NuPlay/RichText

import SwiftUI

extension RichText {
    public func customCSS(_ customCSS: String) -> RichText {
        var result = self
        result.configuration.customCSS += customCSS
        return result
    }
    
    public func lineHeight(_ lineHeight: CGFloat) -> RichText {
        var result = self
        result.configuration.lineHeight = lineHeight
        return result
    }
    
    public func colorScheme(_ colorScheme: ColorScheme) -> RichText {
        var result = self
        result.configuration.colorScheme = colorScheme
        return result
    }

    public func imageRadius(_ imageRadius: CGFloat) -> RichText {
        var result = self
        result.configuration.imageRadius = imageRadius
        return result
    }

    public func fontType(_ fontType: FontType) -> RichText {
        var result = self
        result.configuration.fontType = fontType
        return result
    }
    
    @available(iOS 14.0, *)
    public func foregroundColor(light: Color, dark: Color) -> RichText {
        var result = self
        result.configuration.fontColor = .init(light: UIColor(light), dark: UIColor(dark))
        return result
    }
    
    public func foregroundColor(light: UIColor, dark: UIColor) -> RichText {
        var result = self
        result.configuration.fontColor = .init(light: light, dark: dark)
        return result
    }
    
    @available(iOS 14.0, *)
    public func linkColor(light: Color, dark: Color) -> RichText {
        var result = self
        result.configuration.linkColor = .init(light: UIColor(light), dark: UIColor(dark))
        return result
    }
    
    public func linkColor(light: UIColor, dark: UIColor) -> RichText {
        var result = self
        result.configuration.linkColor = .init(light: light, dark: dark)
        return result
    }

    public func linkOpenType(_ linkOpenType: LinkOpenType) -> RichText {
        var result = self
        result.configuration.linkOpenType = linkOpenType
        return result
    }
    
    public func colorPreference(forceColor: ColorPreference) -> RichText {
        var result = self
        result.configuration.isColorsImportant = forceColor
        
        switch forceColor {
        case .all:
            result.configuration.linkColor.isImportant = true
            result.configuration.fontColor.isImportant = true
        case .onlyLinks:
            result.configuration.linkColor.isImportant = true
            result.configuration.fontColor.isImportant = false
        case .none:
            result.configuration.linkColor.isImportant = false
            result.configuration.fontColor.isImportant = false
        }
        
        return result
    }
    
    public func placeholder<T>(@ViewBuilder content: () -> T) -> RichText where T: View {
        var result = self
        result.placeholder = AnyView(content())
        return result
    }
}

// MARK: - Deprected Functions

public extension RichText {
    @available(*, deprecated, renamed: "colorScheme(_:)")
    func colorScheme(_ colorScheme: colorScheme) -> RichText {
        var result = self
        
        switch colorScheme {
        case .light:
            result.configuration.colorScheme = .light
        case .dark:
            result.configuration.colorScheme = .dark
        case .automatic:
            result.configuration.colorScheme = .auto
        }
        
        return result
    }
    
    @available(*, deprecated, renamed: "colorPreference(_:)")
    func colorImportant(_ colorImportant: Bool) -> RichText {
        var result = self
        result.configuration.isColorsImportant = colorImportant ? .all : .none
        return result
    }
    
    @available(*, deprecated, renamed: "fontType(_:)")
    func fontType(_ fontType: fontType) -> RichText {
        var result = self
        
        switch fontType {
        case .system:
            result.configuration.fontType = .system
        case .monospaced:
            result.configuration.fontType = .monospaced
        case .italic:
            result.configuration.fontType = .italic
        case .default:
            result.configuration.fontType = .system
        }
        
        return result
    }
    
    @available(*, deprecated, renamed: "linkOpenType(_:)")
    func linkOpenType(_ linkOpenType: linkOpenType) -> RichText {
        var result = self
        
        switch linkOpenType {
        case .SFSafariView:
            result.configuration.linkOpenType = .SFSafariView()
        case .SFSafariViewWithReader:
            result.configuration.linkOpenType = .SFSafariView(isReaderActivated: true)
        case .Safari:
            result.configuration.linkOpenType = .Safari
        case .none:
            result.configuration.linkOpenType = .none
        }
        
        return result
    }
}
