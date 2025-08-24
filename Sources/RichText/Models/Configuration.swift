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
    
    public var colorScheme: RichTextColorScheme
    public var forceColorSchemeBackground: Bool
    
    public var backgroundColor: BackgroundColor
    
    public var imageRadius: CGFloat
    
    public var linkOpenType: LinkOpenType
    public var linkColor: ColorSet
    public var baseURL: URL?
    
    public var mediaClickHandler: MediaClickHandler?
    
    public var errorHandler: ErrorHandler?
    
    public var isColorsImportant: ColorPreference
    
    public var transition: Animation?
    
    /// Initializes a new Configuration with default or custom values
    /// - Parameters:
    ///   - customCSS: Additional CSS styles to apply
    ///   - supportsDynamicType: Whether to support Dynamic Type fonts
    ///   - fontType: The type of font to use
    ///   - fontColor: Color set for text
    ///   - lineHeight: Line height percentage
    ///   - colorScheme: Color scheme preference
    ///   - forceColorSchemeBackground: Whether to force background colors
    ///   - backgroundColor: Background color configuration (defaults to transparent)
    ///   - imageRadius: Border radius for images
    ///   - linkOpenType: How links should be opened
    ///   - linkColor: Color set for links
    ///   - baseURL: Base URL for relative resources
    ///   - mediaClickHandler: Handler for image/video click events
    ///   - errorHandler: Handler for error events
    ///   - isColorsImportant: Color preference enforcement
    ///   - transition: Animation for transitions
    public init(
        customCSS: String = "",
        supportsDynamicType: Bool = false,
        fontType: FontType = .system,
        fontColor: ColorSet = .init(
            light: RichTextConstants.defaultLightColor, 
            dark: RichTextConstants.defaultDarkColor
        ),
        lineHeight: CGFloat = RichTextConstants.defaultLineHeight,
        colorScheme: RichTextColorScheme = .auto,
        forceColorSchemeBackground: Bool = false,
        backgroundColor: BackgroundColor = .transparent,
        imageRadius: CGFloat = RichTextConstants.defaultImageRadius,
        linkOpenType: LinkOpenType = .Safari,
        linkColor: ColorSet = .init(
            light: RichTextConstants.defaultLinkLightColor, 
            dark: RichTextConstants.defaultLinkDarkColor, 
            isImportant: true
        ),
        baseURL: URL? = Bundle.main.bundleURL,
        mediaClickHandler: MediaClickHandler? = nil,
        errorHandler: ErrorHandler? = nil,
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
        self.mediaClickHandler = mediaClickHandler
        self.errorHandler = errorHandler
        self.isColorsImportant = isColorsImportant
        self.transition = transition
        
        if supportsDynamicType {
            self.customCSS = self.customCSS + RichTextConstants.dynamicTypeCSS
        }
    }
    
    
    private func backgroundColor(_ isLight: Bool) -> String {
        let baseColor: String
        
        switch backgroundColor {
        case .transparent:
            baseColor = "transparent"
        case .system:
            baseColor = isLight ? "white" : "black"
        case .hex(_):
            baseColor = backgroundColor.cssValue
        case .color(_):
            baseColor = backgroundColor.cssValue
        }
        
        return "\(baseColor) \(forceColorSchemeBackground ? "!important": "")"
    }
    
    /// Generates CSS styles based on configuration and light/dark mode
    /// - Parameters:
    ///   - isLight: Whether to generate styles for light mode
    ///   - alignment: Text alignment preference
    /// - Returns: Generated CSS string
    public func css(isLight: Bool, alignment: TextAlignment) -> String {
        let imageCSS = String(format: RichTextConstants.imageCSS, "\(imageRadius)")
        let textCSS = String(
            format: RichTextConstants.textCSS,
            alignment.htmlDescription,
            "\(lineHeight)",
            fontType.name,
            fontColor.value(isLight),
            backgroundColor(isLight)
        )
        let iframeCSS = String(format: RichTextConstants.iframeCSS, RichTextConstants.iframeHeight)
        let linkCSS = String(format: RichTextConstants.linkCSS, linkColor.value(isLight))
        
        // Add font-specific CSS properties
        let fontSpecificCSS = !fontType.additionalCSSProperties.isEmpty ? 
            "* { \(fontType.additionalCSSProperties) }" : ""
        
        return """
        \(imageCSS)
        \(textCSS)
        \(fontSpecificCSS)
        \(iframeCSS)
        \(linkCSS)
        \(RichTextConstants.linkDecorationCSS)
        \(RichTextConstants.html5ElementsCSS)
        """
    }
    
    /// Generates complete CSS including custom CSS for external usage
    /// - Parameters:
    ///   - colorScheme: Color scheme to use (.light, .dark, or .auto)
    ///   - alignment: Text alignment preference
    /// - Returns: Complete CSS string ready for use
    public func generateCompleteCSS(colorScheme: RichTextColorScheme? = nil, alignment: TextAlignment = .leading) -> String {
        let scheme = colorScheme ?? self.colorScheme
        
        switch scheme {
        case .light:
            return css(isLight: true, alignment: alignment) + "\n" + customCSS
        case .dark:
            return css(isLight: false, alignment: alignment) + "\n" + customCSS
        case .auto:
            return """
            @media (prefers-color-scheme: light) {
                \(css(isLight: true, alignment: alignment))
            }
            @media (prefers-color-scheme: dark) {
                \(css(isLight: false, alignment: alignment))
            }
            \(customCSS)
            """
        }
    }
}
