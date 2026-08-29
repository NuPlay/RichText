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
    
    /// Backing storage for ``isColorsImportant``.
    ///
    /// Kept separate so the framework can carry the value around without tripping its own
    /// deprecation warning.
    var storedColorPreference: ColorPreference

    /// The requested color enforcement preference.
    ///
    /// - Warning: Assigning this does not change the generated CSS. `!important` is driven
    ///   entirely by ``ColorSet/isImportant`` on ``fontColor`` and ``linkColor``, and this
    ///   property has never been read during CSS generation. Use
    ///   ``RichText/colorPreference(forceColor:)``, which sets both color sets, or pass
    ///   `ColorSet(light:dark:isImportant:)` directly.
    @available(*, deprecated, message: "Has no effect on the generated CSS. Use .colorPreference(forceColor:) on the view, or pass ColorSet(light:dark:isImportant:) for fontColor/linkColor.")
    public var isColorsImportant: ColorPreference {
        get { storedColorPreference }
        set { storedColorPreference = newValue }
    }
    
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
    ///   - isColorsImportant: Deprecated. Recorded but never read during CSS generation; use
    ///     `.colorPreference(forceColor:)` or `ColorSet(light:dark:isImportant:)` instead.
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
        self.storedColorPreference = isColorsImportant
        self.transition = transition
        
        if supportsDynamicType {
            self.customCSS = self.customCSS + RichTextConstants.dynamicTypeCSS
        }
    }
    
    
    /// `customCSS` plus the framework-managed overrides that have to win the cascade.
    ///
    /// Dynamic Type is expressed with the `font` shorthand (`font: -apple-system-body`), and a
    /// shorthand resets every longhand it covers, which includes `font-family` and `font-style`.
    /// Since `customCSS` is emitted after the generated rules, turning on `supportsDynamicType`
    /// silently discarded `fontType`: `.monospaced`, `.italic` and `.customName` all fell back to
    /// the default family. Re-assert the configured font after the Dynamic Type rules so the two
    /// options can be used together.
    public var resolvedCustomCSS: String {
        guard supportsDynamicType, requiresFontOverride else {
            return customCSS
        }

        // `p.subheadline` and friends have to be named explicitly. A bare `p` selector has
        // specificity (0,0,1) and would lose to the Dynamic Type `p.subheadline { font: ... }`
        // rule at (0,1,1) no matter how late it appears, so those paragraphs would keep
        // resetting `font-family`. Matching the specificity lets source order decide, and the
        // override is emitted last.
        let fontOverrideCSS = """
        html, body, h1, h2, h3, h4, h5, h6, p, p.subheadline, p.footnote, p.caption1, p.caption2 { font-family: \(fontType.name); \(fontType.additionalCSSProperties) }
        """

        return customCSS + "\n" + fontOverrideCSS
    }

    /// Whether the configured font actually differs from what the Dynamic Type shorthands
    /// already produce.
    ///
    /// For the default system font the shorthand result and the configured font are the same,
    /// so emitting an override would buy nothing and would clobber a caller's own
    /// `font-family` rule in `customCSS`.
    private var requiresFontOverride: Bool {
        fontType.name != RichTextConstants.systemFontName || !fontType.additionalCSSProperties.isEmpty
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
        let imageCSS = RichTextConstants.imageCSS(radius: imageRadius)
        let textCSS = RichTextConstants.textCSS(
            alignment: alignment.htmlDescription,
            lineHeight: lineHeight,
            fontFamily: fontType.name,
            color: fontColor.value(isLight),
            backgroundColor: backgroundColor(isLight)
        )
        let iframeCSS = RichTextConstants.iframeCSS()
        let linkCSS = RichTextConstants.linkCSS(color: linkColor.value(isLight))
        
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
            return css(isLight: true, alignment: alignment) + "\n" + resolvedCustomCSS
        case .dark:
            return css(isLight: false, alignment: alignment) + "\n" + resolvedCustomCSS
        case .auto:
            return """
            @media (prefers-color-scheme: light) {
                \(css(isLight: true, alignment: alignment))
            }
            @media (prefers-color-scheme: dark) {
                \(css(isLight: false, alignment: alignment))
            }
            \(resolvedCustomCSS)
            """
        }
    }
}
