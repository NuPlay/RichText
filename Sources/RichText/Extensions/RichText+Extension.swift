//
//  RichTextExtension.swift
//  
//
//  Created by 이웅재(NuPlay) on 2021/08/27.
//  https://github.com/NuPlay/RichText

import SwiftUI

extension RichText {

    public func lineHeight(_ lineHeight: CGFloat) -> RichText {
        var result = self

        result.lineHeight = lineHeight
        return result
    }

    public func imageRadius(_ imageRadius: CGFloat) -> RichText {
        var result = self

        result.imageRadius = imageRadius
        return result
    }

    public func fontType(_ fontType: FontType) -> RichText {
        var result = self

        result.fontType = fontType
        return result
    }

    public func colorScheme(_ colorScheme: ColorScheme) -> RichText {
        var result = self

        result.colorScheme = colorScheme
        return result
    }

    public func colorImportant(_ colorImportant: Bool) -> RichText {
        var result = self

        result.colorImportant = colorImportant
        return result
    }

    public func placeholder<T>(@ViewBuilder content: () -> T) -> RichText where T: View {
        var result = self

        result.placeholder = AnyView(content())
        return result
    }

    public func linkOpenType(_ linkOpenType: LinkOpenType) -> RichText {
        var result = self

        result.linkOpenType = linkOpenType
        return result
    }

    public func linkColor(_ linkColor: ColorSet) -> RichText {
        var result = self

        result.linkColor = linkColor
        return result
    }
    
    public func customCSS(_ customCSS: String) -> RichText {
        var result = self
        
        result.customCSS += customCSS
        return result
    }
}
