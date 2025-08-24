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
    
    public func colorScheme(_ colorScheme: RichTextColorScheme) -> RichText {
        var result = self
        result.configuration.colorScheme = colorScheme
        return result
    }
    
    public func forceColorSchemeBackground(_ forceColorSchemeBackground: Bool) -> RichText {
        var result = self
        result.configuration.forceColorSchemeBackground = forceColorSchemeBackground
        return result
    }
    
    public func backgroundColor(_ backgroundColor: BackgroundColor) -> RichText {
        var result = self
        result.configuration.backgroundColor = backgroundColor
        return result
    }
    
    public func backgroundColorHex(_ hexColor: String) -> RichText {
        var result = self
        result.configuration.backgroundColor = .hex(hexColor)
        return result
    }
    
    public func backgroundColorSwiftUI(_ color: Color) -> RichText {
        var result = self
        result.configuration.backgroundColor = .color(color)
        return result
    }
    
    public func transparentBackground() -> RichText {
        var result = self
        result.configuration.backgroundColor = .transparent
        return result
    }
    
    // MARK: - Backward Compatibility
    
    /// Sets background color using string (for backward compatibility)
    /// - Parameter backgroundColor: CSS color string (e.g., "transparent", "#FF0000", "rgba(255,0,0,0.5)")
    /// - Returns: RichText with updated background color
    @available(*, deprecated, message: "Use backgroundColor(_: BackgroundColor) or specific methods like transparentBackground(), backgroundColorHex(_:), etc.")
    public func backgroundColor(_ backgroundColor: String?) -> RichText {
        var result = self
        if let bg = backgroundColor {
            if bg.lowercased() == "transparent" {
                result.configuration.backgroundColor = .transparent
            } else if bg.lowercased() == "inherit" {
                result.configuration.backgroundColor = .system
            } else {
                result.configuration.backgroundColor = .hex(bg)
            }
        } else {
            result.configuration.backgroundColor = .transparent
        }
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
    
    #if canImport(UIKit)
    @available(iOS 14.0, *)
    @available(*, deprecated, message: "Use textColor(light:dark:) for better semantic clarity")
    public func foregroundColor(light: Color, dark: Color) -> RichText {
        return setColors(light: UIColor(light), dark: UIColor(dark), isLink: false)
    }

    @available(*, deprecated, message: "Use textColor(light:dark:) for better semantic clarity")
    public func foregroundColor(light: UIColor, dark: UIColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: false)
    }
    #else
    @available(*, deprecated, message: "Use textColor(light:dark:) for better semantic clarity")
    public func foregroundColor(light: NSColor, dark: NSColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: false)
    }
    #endif
    
    #if canImport(UIKit)
    @available(iOS 14.0, *)
    public func linkColor(light: Color, dark: Color) -> RichText {
        return setColors(light: UIColor(light), dark: UIColor(dark), isLink: true)
    }
    
    public func linkColor(light: UIColor, dark: UIColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: true)
    }
    #else
    public func linkColor(light: NSColor, dark: NSColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: true)
    }
    #endif

    public func linkOpenType(_ linkOpenType: LinkOpenType) -> RichText {
        var result = self
        result.configuration.linkOpenType = linkOpenType
        return result
    }

    public func baseURL(_ baseURL: URL) -> RichText {
        var result = self
        result.configuration.baseURL = baseURL
        return result
    }
    
    public func onMediaClick(_ handler: @escaping MediaClickHandler) -> RichText {
        var result = self
        result.configuration.mediaClickHandler = handler
        return result
    }
    
    public func onError(_ handler: @escaping ErrorHandler) -> RichText {
        var result = self
        result.configuration.errorHandler = handler
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
    
    // MARK: - Modern Replacement Methods
    
    #if canImport(UIKit)
    /// Modern replacement for foregroundColor methods with better semantic clarity
    /// - Parameters:
    ///   - light: Text color for light mode
    ///   - dark: Text color for dark mode
    /// - Returns: RichText with updated text colors
    @available(iOS 14.0, *)
    public func textColor(light: Color, dark: Color) -> RichText {
        return setColors(light: UIColor(light), dark: UIColor(dark), isLink: false)
    }
    
    public func textColor(light: UIColor, dark: UIColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: false)
    }
    #else
    public func textColor(light: NSColor, dark: NSColor) -> RichText {
        return setColors(light: light, dark: dark, isLink: false)
    }
    #endif
    
    public func placeholder<T>(@ViewBuilder content: () -> T) -> RichText where T: View {
        var result = self
        result.placeholder = AnyView(content())
        return result
    }
    
    /// Convenience method for default loading placeholder with custom text  
    /// - Parameter text: Loading text to display (default: "Loading...")
    /// - Returns: RichText with default loading placeholder
    @available(iOS 14.0, macOS 11.0, *)
    @available(*, deprecated, message: "Use placeholder { } with custom view for better flexibility and consistency")
    public func loadingPlaceholder(_ text: String = "Loading...") -> RichText {
        var result = self
        result.placeholder = AnyView(
            HStack(spacing: 8) {
                ProgressView()
                    .scaleEffect(0.8)
                Text(text)
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, minHeight: 60)
        )
        return result
    }
    
    /// Sets a simple text loading placeholder
    /// - Parameter text: Loading text (default: "Loading...")
    /// - Returns: RichText with simple text placeholder
    @available(*, deprecated, message: "Use placeholder { Text(\"Loading...\") } for better consistency")
    public func loadingText(_ text: String = "Loading...") -> RichText {
        var result = self
        result.placeholder = AnyView(
            Text(text)
                .foregroundColor(.secondary)
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 60)
        )
        return result
    }
    
    @available(*, deprecated, message: "Use loadingTransition(_:) for type-safe animation configuration")
    public func transition(_ transition: Animation?) -> RichText {
        var result = self
        result.configuration.transition = transition
        return result
    }
    
    public func loadingTransition(_ transition: LoadingTransition) -> RichText {
        var result = self
        result.configuration.transition = transition.animation
        return result
    }
    
    /// Returns the generated CSS for the current configuration
    /// - Parameters:
    ///   - colorScheme: Optional color scheme override
    ///   - alignment: Text alignment (default: leading)
    /// - Returns: Complete CSS string
    public func generateCSS(colorScheme: RichTextColorScheme? = nil, alignment: TextAlignment = .leading) -> String {
        return configuration.generateCompleteCSS(colorScheme: colorScheme, alignment: alignment)
    }
    
    // MARK: - Private Helper Methods
    
    #if canImport(UIKit)
    private func setColors(light: UIColor, dark: UIColor, isLink: Bool) -> RichText {
        var result = self
        let colorSet = ColorSet(light: light, dark: dark)
        if isLink {
            result.configuration.linkColor = colorSet
        } else {
            result.configuration.fontColor = colorSet
        }
        return result
    }
    #else
    private func setColors(light: NSColor, dark: NSColor, isLink: Bool) -> RichText {
        var result = self
        let colorSet = ColorSet(light: light, dark: dark)
        if isLink {
            result.configuration.linkColor = colorSet
        } else {
            result.configuration.fontColor = colorSet
        }
        return result
    }
    #endif
}

