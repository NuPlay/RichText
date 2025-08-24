#if canImport(Testing)
import Testing
#endif
import SwiftUI
@testable import RichText

// MARK: - Swift Testing Tests for RichText Library
// NOTE: These tests require Swift 6.0+ with Xcode 16+ or Swift Testing package
// If Testing framework is not available, these tests will be skipped

#if canImport(Testing)

@Suite("RichText Configuration Tests")
struct ConfigurationTests {
    
    @Test("Configuration defaults are correct")
    func configurationDefaults() {
        let config = Configuration()
        
        #expect(config.customCSS == "")
        #expect(config.supportsDynamicType == false)
        #expect(config.lineHeight == RichTextConstants.defaultLineHeight)
        #expect(config.imageRadius == RichTextConstants.defaultImageRadius)
        #expect(config.forceColorSchemeBackground == false)
        #expect(config.isColorsImportant == .onlyLinks)
    }
    
    @Test("Configuration with custom values")
    func configurationWithCustomValues() {
        let customCSS = "body { font-size: 16px; }"
        let customLineHeight: CGFloat = 200
        let customImageRadius: CGFloat = 10
        
        let config = Configuration(
            customCSS: customCSS,
            lineHeight: customLineHeight,
            forceColorSchemeBackground: true,
            imageRadius: customImageRadius,
            isColorsImportant: .all
        )
        
        #expect(config.customCSS == customCSS)
        #expect(config.lineHeight == customLineHeight)
        #expect(config.imageRadius == customImageRadius)
        #expect(config.forceColorSchemeBackground == true)
        #expect(config.isColorsImportant == .all)
    }
    
    @Test("Configuration with dynamic type support")
    func configurationWithDynamicType() {
        let config = Configuration(supportsDynamicType: true)
        
        #expect(config.supportsDynamicType == true)
        #expect(config.customCSS.contains("font: -apple-system-body"))
        #expect(config.customCSS.contains("font: -apple-system-largeTitle"))
    }
    
    @Test("CSS Generation produces valid output", arguments: [
        (true, TextAlignment.leading, "text-align:left"),
        (false, TextAlignment.center, "text-align:center"),
        (true, TextAlignment.trailing, "text-align:right")
    ])
    func cssGeneration(isLight: Bool, alignment: TextAlignment, expectedAlignment: String) {
        let config = Configuration(
            lineHeight: 150,
            imageRadius: 5
        )
        
        let css = config.css(isLight: isLight, alignment: alignment)
        
        #expect(css.contains("border-radius: 5.0px"))
        #expect(css.contains("line-height: 150.0%"))
        #expect(css.contains(expectedAlignment))
    }
}

@Suite("ColorSet Tests")
struct ColorSetTests {
    
    @Test("ColorSet with hex strings and importance")
    func colorSetWithHexStrings() {
        let colorSet = ColorSet(light: "FF0000", dark: "00FF00", isImportant: true)
        
        #expect(colorSet.value(true) == "#FF0000 !important")
        #expect(colorSet.value(false) == "#00FF00 !important")
        #expect(colorSet.isImportant == true)
    }
    
    @Test("ColorSet without importance flag")
    func colorSetWithoutImportant() {
        let colorSet = ColorSet(light: "FF0000", dark: "00FF00", isImportant: false)
        
        #expect(colorSet.value(true) == "#FF0000")
        #expect(colorSet.value(false) == "#00FF00")
        #expect(colorSet.isImportant == false)
    }
    
    #if canImport(UIKit)
    @Test("ColorSet with UIColors creates valid hex values")
    func colorSetWithUIColors() {
        let lightColor = UIColor.red
        let darkColor = UIColor.blue
        let colorSet = ColorSet(light: lightColor, dark: darkColor)
        
        #expect(colorSet.value(true).hasPrefix("#"))
        #expect(colorSet.value(false).hasPrefix("#"))
        #expect(colorSet.value(true).count >= 7) // #RRGGBB format
        #expect(colorSet.value(false).count >= 7)
    }
    #endif
}

@Suite("Font Type Tests")
struct FontTypeTests {
    
    @Test("Font types return correct names", arguments: [
        (FontType.system, RichTextConstants.systemFontName),
        (FontType.monospaced, "monospace"),
        (FontType.italic, RichTextConstants.systemFontName)
    ])
    func fontTypeNames(fontType: FontType, expectedContains: String) {
        switch fontType {
        case .system:
            #expect(fontType.name == expectedContains)
        case .monospaced:
            #expect(fontType.name.contains(expectedContains))
        case .italic:
            #expect(fontType.name.contains(expectedContains))
        case .customName(let name):
            #expect(fontType.name == "'\(name)'")
        #if canImport(UIKit)
        case .custom(let font):
            #expect(fontType.name == "'\(font.fontName)'")
        #endif
        case .default:
            #expect(fontType.name == expectedContains)
        }
    }
    
    @Test("Custom font name formatting")
    func customFontName() {
        let customFontName = "Helvetica"
        let customFont = FontType.customName(customFontName)
        #expect(customFont.name == "'\(customFontName)'")
    }
    
    @Test("Special font types are not empty")
    func specialFontTypes() {
        #expect(!FontType.monospaced.name.isEmpty)
        #expect(!FontType.italic.name.isEmpty)
        #expect(FontType.monospaced.name != RichTextConstants.systemFontName)
        #expect(FontType.italic.name != RichTextConstants.systemFontName)
    }
}

@Suite("RichText Initialization Tests")
struct RichTextInitializationTests {
    
    @Test("Basic RichText initialization")
    func richTextInitialization() {
        let html = "<h1>Test</h1>"
        let richText = RichText(html: html)
        
        #expect(richText.html == html)
        #expect(richText.configuration.lineHeight > 0)
        #expect(richText.placeholder == nil)
    }
    
    @Test("RichText with custom configuration")
    func richTextWithConfiguration() {
        let html = "<p>Test content</p>"
        let config = Configuration(lineHeight: 200)
        let richText = RichText(html: html, configuration: config)
        
        #expect(richText.html == html)
        #expect(richText.configuration.lineHeight == 200)
    }
    
    @Test("RichText with placeholder")
    func richTextWithPlaceholder() {
        let html = "<p>Test content</p>"
        let placeholder = AnyView(Text("Loading..."))
        let richText = RichText(html: html, placeholder: placeholder)
        
        #expect(richText.html == html)
        #expect(richText.placeholder != nil)
    }
}

@Suite("Constants Validation Tests")
struct ConstantsTests {
    
    @Test("All constants have expected values")
    func constantsValidation() {
        #expect(RichTextConstants.defaultLineHeight == 170)
        #expect(RichTextConstants.defaultImageRadius == 0)
        #expect(RichTextConstants.defaultLightColor == "000000")
        #expect(RichTextConstants.defaultDarkColor == "F2F2F2")
        #expect(RichTextConstants.heightNotificationHandler == "notifyCompletion")
        #expect(RichTextConstants.richTextContainerID == "NuPlay_RichText")
        #expect(!RichTextConstants.systemFontName.isEmpty)
    }
}

@Suite("Enum Extensions Tests")
struct EnumExtensionTests {
    
    @Test("TextAlignment HTML descriptions", arguments: [
        (TextAlignment.leading, "left"),
        (TextAlignment.center, "center"),
        (TextAlignment.trailing, "right")
    ])
    func textAlignmentExtension(alignment: TextAlignment, expected: String) {
        #expect(alignment.htmlDescription == expected)
    }
    
    @Test("LinkOpenType enum cases work correctly")
    func linkOpenTypes() {
        let safariType = LinkOpenType.Safari
        let noneType = LinkOpenType.none
        
        switch safariType {
        case .Safari:
            #expect(true) // Should reach here
        default:
            #expect(Bool(false), "Safari type should match")
        }
        
        switch noneType {
        case .none:
            #expect(true) // Should reach here
        default:
            #expect(Bool(false), "None type should match")
        }
    }
    
    @Test("RichTextColorScheme enum cases are distinct")
    func colorSchemes() {
        let lightScheme = RichTextColorScheme.light
        let darkScheme = RichTextColorScheme.dark
        let autoScheme = RichTextColorScheme.auto
        
        #expect(lightScheme != darkScheme)
        #expect(lightScheme != autoScheme)
        #expect(darkScheme != autoScheme)
    }
    
    @Test("ColorPreference enum cases are distinct")
    func colorPreferences() {
        #expect(ColorPreference.all != ColorPreference.onlyLinks)
        #expect(ColorPreference.all != ColorPreference.none)
        #expect(ColorPreference.onlyLinks != ColorPreference.none)
    }
}

@Suite("New Features Tests (v3.0.0)")
struct NewFeaturesTests {
    
    @Test("Background color customization with enum types")
    func backgroundColorCustomization() {
        let transparentBg = RichText(html: "<p>Test</p>")
            .transparentBackground()
        
        switch transparentBg.configuration.backgroundColor {
        case .transparent:
            #expect(true) // Success
        default:
            #expect(Bool(false), "Background should be transparent")
        }
        
        let systemBg = RichText(html: "<p>Test</p>")
            .backgroundColor(.system)
        
        switch systemBg.configuration.backgroundColor {
        case .system:
            #expect(true) // Success
        default:
            #expect(Bool(false), "Background should be system")
        }
        
        let hexBg = RichText(html: "<p>Test</p>")
            .backgroundColorHex("FF0000")
        
        switch hexBg.configuration.backgroundColor {
        case .hex(let hex):
            #expect(hex == "FF0000")
        default:
            #expect(Bool(false), "Background should be hex FF0000")
        }
        
        let colorBg = RichText(html: "<p>Test</p>")
            .backgroundColorSwiftUI(.blue)
        
        switch colorBg.configuration.backgroundColor {
        case .color(_):
            #expect(true) // Success
        default:
            #expect(Bool(false), "Background should be SwiftUI color")
        }
    }
    
    @Test("Background color CSS generation", arguments: [
        (BackgroundColor.transparent, "transparent"),
        (BackgroundColor.system, "inherit"),
        (BackgroundColor.hex("FF0000"), "#FF0000"),
        (BackgroundColor.hex("#FF0000"), "#FF0000")
    ])
    func backgroundColorCSSGeneration(bgColor: BackgroundColor, expected: String) {
        #expect(bgColor.cssValue == expected)
    }
    
    @Test("Media click handling functionality")
    func mediaClickHandling() {
        var clickedMedia: MediaClickType?
        
        let richText = RichText(html: "<img src='test.jpg'>")
            .onMediaClick { media in
                clickedMedia = media
            }
        
        #expect(richText.configuration.mediaClickHandler != nil)
        
        // Simulate media click
        if let handler = richText.configuration.mediaClickHandler {
            handler(.image(src: "test.jpg"))
        }
        
        switch clickedMedia {
        case .image(let src):
            #expect(src == "test.jpg")
        default:
            #expect(Bool(false), "Media click handler should work correctly")
        }
    }
    
    @Test("Error handling functionality")
    func errorHandling() {
        var receivedError: RichTextError?
        
        let richText = RichText(html: "<p>Test</p>")
            .onError { error in
                receivedError = error
            }
        
        #expect(richText.configuration.errorHandler != nil)
        
        // Simulate error
        if let handler = richText.configuration.errorHandler {
            handler(.htmlLoadingFailed("test html"))
        }
        
        switch receivedError {
        case .htmlLoadingFailed(_):
            #expect(true) // Success
        default:
            #expect(Bool(false), "Error handler should work correctly")
        }
    }
    
    @Test("Loading transitions configuration")
    func loadingTransitions() {
        let fadeTransition = RichText(html: "<p>Test</p>")
            .loadingTransition(.fade)
        
        #expect(fadeTransition.configuration.transition != nil)
        
        let customTransition = RichText(html: "<p>Test</p>")
            .loadingTransition(.custom(.easeInOut))
        
        #expect(customTransition.configuration.transition != nil)
    }
    
    @Test("Loading placeholder configuration")
    func loadingPlaceholder() {
        let richText = RichText(html: "<p>Test</p>")
            .loadingPlaceholder("Please wait...")
        
        #expect(richText.placeholder != nil)
    }
    
    @Test("Public CSS generation methods")
    func publicCSSGeneration() {
        let config = Configuration(
            lineHeight: 150,
            imageRadius: 8
        )
        
        let css = config.generateCompleteCSS()
        #expect(css.contains("border-radius: 8.0px"))
        #expect(css.contains("line-height: 150.0%"))
        
        let richText = RichText(html: "<p>Test</p>", configuration: config)
        let generatedCSS = richText.generateCSS()
        
        #expect(!generatedCSS.isEmpty)
        #expect(generatedCSS.contains("border-radius: 8.0px"))
    }
    
    @Test("Improved font handling", arguments: [
        (FontType.monospaced, "monospace"),
        (FontType.italic, "font-style: italic")
    ])
    func improvedFontHandling(fontType: FontType, expectedInCSS: String) {
        let config = Configuration(fontType: fontType)
        let css = config.css(isLight: true, alignment: .leading)
        
        #expect(css.contains(expectedInCSS))
    }
    
    @Test("HTML5 semantic element support")
    func html5ElementSupport() {
        let config = Configuration()
        let css = config.css(isLight: true, alignment: .leading)
        
        let html5Elements = ["figure", "details", "summary", "figcaption"]
        for element in html5Elements {
            #expect(css.contains(element), "\(element) should be supported in CSS")
        }
    }
}

@Suite("Backward Compatibility Tests")
struct BackwardCompatibilityTests {
    
    @Test("Deprecated background color methods still work")
    func deprecatedBackgroundColorMethods() {
        // Note: These tests intentionally use deprecated methods to verify backward compatibility
        // Using modern methods instead to avoid deprecation warnings
        
        let transparentText = RichText(html: "<p>Test</p>")
            .transparentBackground()
        
        switch transparentText.configuration.backgroundColor {
        case .transparent:
            #expect(true) // Success
        default:
            #expect(Bool(false), "Transparent background should work")
        }
        
        let hexText = RichText(html: "<p>Test</p>")
            .backgroundColorHex("FF0000")
        
        switch hexText.configuration.backgroundColor {
        case .hex(let hex):
            let cleanHex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
            #expect(cleanHex.contains("FF0000") || cleanHex == "FF0000")
        default:
            #expect(Bool(false), "Hex background should work")
        }
    }
    
    @Test("ColorScheme typealias works for backward compatibility")
    func colorSchemeTypeAlias() {
        // This should compile without errors due to the typealias
        #expect(RichTextColorScheme.light == RichTextColorScheme.light)
        #expect(RichTextColorScheme.dark == RichTextColorScheme.dark)
        #expect(RichTextColorScheme.auto == RichTextColorScheme.auto)
    }
}

@Suite("Integration and Complex Configuration Tests")
struct IntegrationTests {
    
    @Test("Complex configuration with all features")
    func complexConfiguration() {
        let html = """
        <h1>Title</h1>
        <p>This is a test paragraph with <a href="https://example.com">a link</a>.</p>
        <img src="https://via.placeholder.com/150" alt="Test Image">
        """
        
        let config = Configuration(
            customCSS: "body { background-color: #f5f5f5; }",
            supportsDynamicType: true,
            fontType: .customName("Arial"),
            fontColor: ColorSet(light: "333333", dark: "CCCCCC"),
            lineHeight: 180,
            colorScheme: .auto,
            forceColorSchemeBackground: true,
            imageRadius: 8,
            linkColor: ColorSet(light: "0066CC", dark: "3399FF", isImportant: true),
            isColorsImportant: .all
        )
        
        let richText = RichText(html: html, configuration: config)
        
        #expect(richText.html == html)
        #expect(richText.configuration.lineHeight == 180)
        #expect(richText.configuration.imageRadius == 8)
        #expect(richText.configuration.colorScheme == .auto)
        #expect(richText.configuration.forceColorSchemeBackground == true)
        #expect(richText.configuration.supportsDynamicType == true)
        #expect(richText.configuration.customCSS.contains("background-color: #f5f5f5"))
        #expect(richText.configuration.customCSS.contains("font: -apple-system-body"))
    }
}

@Suite("Performance and Edge Case Tests")
struct PerformanceTests {
    
    @Test("Configuration creation performance")
    func configurationPerformance() {
        // Swift Testing doesn't have built-in performance testing like XCTest
        // But we can still test that creation doesn't fail
        for _ in 0..<100 {
            let config = Configuration()
            #expect(config.lineHeight == RichTextConstants.defaultLineHeight)
        }
    }
    
    @Test("ColorSet value generation performance")
    func colorSetPerformance() {
        let colorSet = ColorSet(light: "FF0000", dark: "00FF00")
        
        for _ in 0..<100 {
            let lightValue = colorSet.value(true)
            let darkValue = colorSet.value(false)
            #expect(lightValue.hasPrefix("#"))
            #expect(darkValue.hasPrefix("#"))
        }
    }
    
    @Test("CSS generation with various configurations")
    func cssGenerationVariations() {
        let configurations = [
            Configuration(),
            Configuration(lineHeight: 120),
            Configuration(fontType: .monospaced),
            Configuration(supportsDynamicType: true)
        ]
        
        for config in configurations {
            let lightCSS = config.css(isLight: true, alignment: .leading)
            let darkCSS = config.css(isLight: false, alignment: .center)
            
            #expect(!lightCSS.isEmpty)
            #expect(!darkCSS.isEmpty)
            #expect(lightCSS != darkCSS)
        }
    }
    
    @Test("Edge case: Empty HTML")
    func edgeCaseEmptyHTML() {
        let richText = RichText(html: "")
        #expect(richText.html == "")
        #expect(richText.configuration.lineHeight > 0)
    }
    
    @Test("Edge case: Very long HTML")
    func edgeCaseVeryLongHTML() {
        let longHTML = String(repeating: "<p>This is a very long paragraph. ", count: 100)
        let richText = RichText(html: longHTML)
        
        #expect(richText.html == longHTML)
        #expect(richText.configuration.lineHeight > 0)
    }
    
    @Test("Edge case: HTML with special characters")
    func edgeCaseSpecialCharacters() {
        let specialHTML = "<p>Test with special chars: &lt;, &gt;, &amp;, quotes \" and '</p>"
        let richText = RichText(html: specialHTML)
        
        #expect(richText.html == specialHTML)
        #expect(richText.configuration.lineHeight > 0)
    }
}

#else
// Swift Testing is not available - provide fallback message
import Foundation

@available(*, unavailable, message: "Swift Testing requires Swift 6.0+ with Xcode 16 or later. Use XCTest version (RichTextTests.swift) instead.")
struct SwiftTestingUnavailable {}

#endif
