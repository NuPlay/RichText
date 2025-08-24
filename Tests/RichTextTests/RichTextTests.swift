import XCTest
import SwiftUI
@testable import RichText

final class RichTextTests: XCTestCase {
    
    // MARK: - Configuration Tests
    
    func testConfigurationDefaults() {
        let config = Configuration()
        
        XCTAssertEqual(config.customCSS, "")
        XCTAssertEqual(config.supportsDynamicType, false)
        XCTAssertEqual(config.lineHeight, RichTextConstants.defaultLineHeight)
        XCTAssertEqual(config.imageRadius, RichTextConstants.defaultImageRadius)
        XCTAssertEqual(config.forceColorSchemeBackground, false)
        XCTAssertEqual(config.isColorsImportant, .onlyLinks)
    }
    
    func testConfigurationWithCustomValues() {
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
        
        XCTAssertEqual(config.customCSS, customCSS)
        XCTAssertEqual(config.lineHeight, customLineHeight)
        XCTAssertEqual(config.imageRadius, customImageRadius)
        XCTAssertEqual(config.forceColorSchemeBackground, true)
        XCTAssertEqual(config.isColorsImportant, .all)
    }
    
    func testConfigurationWithDynamicType() {
        let config = Configuration(supportsDynamicType: true)
        
        XCTAssertTrue(config.supportsDynamicType)
        XCTAssertTrue(config.customCSS.contains("font: -apple-system-body"))
        XCTAssertTrue(config.customCSS.contains("font: -apple-system-largeTitle"))
    }
    
    // MARK: - ColorSet Tests
    
    func testColorSetWithHexStrings() {
        let colorSet = ColorSet(light: "FF0000", dark: "00FF00", isImportant: true)
        
        XCTAssertEqual(colorSet.value(true), "#FF0000 !important")
        XCTAssertEqual(colorSet.value(false), "#00FF00 !important")
        XCTAssertTrue(colorSet.isImportant)
    }
    
    func testColorSetWithoutImportant() {
        let colorSet = ColorSet(light: "FF0000", dark: "00FF00", isImportant: false)
        
        XCTAssertEqual(colorSet.value(true), "#FF0000")
        XCTAssertEqual(colorSet.value(false), "#00FF00")
        XCTAssertFalse(colorSet.isImportant)
    }
    
    #if canImport(UIKit)
    func testColorSetWithUIColors() {
        let lightColor = UIColor.red
        let darkColor = UIColor.blue
        let colorSet = ColorSet(light: lightColor, dark: darkColor)
        
        // Should create valid hex values
        XCTAssertTrue(colorSet.value(true).hasPrefix("#"))
        XCTAssertTrue(colorSet.value(false).hasPrefix("#"))
    }
    #endif
    
    // MARK: - FontType Tests
    
    func testSystemFontName() {
        let systemFont = FontType.system
        XCTAssertEqual(systemFont.name, RichTextConstants.systemFontName)
    }
    
    func testCustomFontName() {
        let customFontName = "Helvetica"
        let customFont = FontType.customName(customFontName)
        XCTAssertEqual(customFont.name, "'\(customFontName)'")
    }
    
    func testMonospacedFont() {
        let monoFont = FontType.monospaced
        XCTAssertNotEqual(monoFont.name, RichTextConstants.systemFontName)
        XCTAssertFalse(monoFont.name.isEmpty)
    }
    
    func testItalicFont() {
        let italicFont = FontType.italic
        XCTAssertNotEqual(italicFont.name, RichTextConstants.systemFontName)
        XCTAssertFalse(italicFont.name.isEmpty)
    }
    
    // MARK: - RichText Initialization Tests
    
    func testRichTextInitialization() {
        let html = "<h1>Test</h1>"
        let richText = RichText(html: html)
        
        XCTAssertEqual(richText.html, html)
        XCTAssertNotNil(richText.configuration)
        XCTAssertNil(richText.placeholder)
    }
    
    func testRichTextWithConfiguration() {
        let html = "<p>Test content</p>"
        let config = Configuration(lineHeight: 200)
        let richText = RichText(html: html, configuration: config)
        
        XCTAssertEqual(richText.html, html)
        XCTAssertEqual(richText.configuration.lineHeight, 200)
    }
    
    func testRichTextWithPlaceholder() {
        let html = "<p>Test content</p>"
        let placeholder = AnyView(Text("Loading..."))
        let richText = RichText(html: html, placeholder: placeholder)
        
        XCTAssertEqual(richText.html, html)
        XCTAssertNotNil(richText.placeholder)
    }
    
    // MARK: - CSS Generation Tests
    
    func testCSSGeneration() {
        let config = Configuration(
            lineHeight: 150,
            imageRadius: 5
        )
        
        let css = config.css(isLight: true, alignment: .leading)
        
        XCTAssertTrue(css.contains("border-radius: 5.0px"))
        XCTAssertTrue(css.contains("line-height: 150.0%"))
        XCTAssertTrue(css.contains("text-align:left"))
    }
    
    func testCSSGenerationDarkMode() {
        let config = Configuration()
        let lightCSS = config.css(isLight: true, alignment: .center)
        let darkCSS = config.css(isLight: false, alignment: .center)
        
        XCTAssertNotEqual(lightCSS, darkCSS)
        XCTAssertTrue(lightCSS.contains("text-align:center"))
        XCTAssertTrue(darkCSS.contains("text-align:center"))
    }
    
    // MARK: - Constants Tests
    
    func testConstants() {
        XCTAssertEqual(RichTextConstants.defaultLineHeight, 170)
        XCTAssertEqual(RichTextConstants.defaultImageRadius, 0)
        XCTAssertEqual(RichTextConstants.defaultLightColor, "000000")
        XCTAssertEqual(RichTextConstants.defaultDarkColor, "F2F2F2")
        XCTAssertEqual(RichTextConstants.heightNotificationHandler, "notifyCompletion")
        XCTAssertEqual(RichTextConstants.richTextContainerID, "NuPlay_RichText")
    }
    
    // MARK: - Text Alignment Tests
    
    func testTextAlignmentExtension() {
        XCTAssertEqual(TextAlignment.leading.htmlDescription, "left")
        XCTAssertEqual(TextAlignment.center.htmlDescription, "center")
        XCTAssertEqual(TextAlignment.trailing.htmlDescription, "right")
    }
    
    // MARK: - Link Open Type Tests
    
    func testLinkOpenTypes() {
        let safariType = LinkOpenType.Safari
        let noneType = LinkOpenType.none
        
        // These should not crash when accessed
        switch safariType {
        case .Safari: break
        default: XCTFail("Safari type should match")
        }
        
        switch noneType {
        case .none: break
        default: XCTFail("None type should match")
        }
    }
    
    // MARK: - Color Scheme Tests
    
    func testColorSchemes() {
        let lightScheme = RichTextColorScheme.light
        let darkScheme = RichTextColorScheme.dark
        let autoScheme = RichTextColorScheme.auto
        
        XCTAssertNotEqual(lightScheme, darkScheme)
        XCTAssertNotEqual(lightScheme, autoScheme)
        XCTAssertNotEqual(darkScheme, autoScheme)
    }
    
    // MARK: - Color Preference Tests
    
    func testColorPreferences() {
        XCTAssertNotEqual(ColorPreference.all, ColorPreference.onlyLinks)
        XCTAssertNotEqual(ColorPreference.all, ColorPreference.none)
        XCTAssertNotEqual(ColorPreference.onlyLinks, ColorPreference.none)
    }
    
    // MARK: - Integration Tests
    
    func testComplexConfiguration() {
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
        
        XCTAssertEqual(richText.html, html)
        XCTAssertEqual(richText.configuration.lineHeight, 180)
        XCTAssertEqual(richText.configuration.imageRadius, 8)
        XCTAssertEqual(richText.configuration.colorScheme, .auto)
        XCTAssertTrue(richText.configuration.forceColorSchemeBackground)
        XCTAssertTrue(richText.configuration.supportsDynamicType)
        XCTAssertTrue(richText.configuration.customCSS.contains("background-color: #f5f5f5"))
        XCTAssertTrue(richText.configuration.customCSS.contains("font: -apple-system-body"))
    }
    
    // MARK: - New Features Tests (v3.0.0)
    
    func testBackgroundColorCustomization() {
        // Test new enum-based background colors
        let transparentBg = RichText(html: "<p>Test</p>")
            .transparentBackground()
        if case .transparent = transparentBg.configuration.backgroundColor {
            XCTAssertTrue(true)
        } else {
            XCTFail("Background should be transparent")
        }
        
        let systemBg = RichText(html: "<p>Test</p>")
            .backgroundColor(.system)
        if case .system = systemBg.configuration.backgroundColor {
            XCTAssertTrue(true)
        } else {
            XCTFail("Background should be system")
        }
        
        let hexBg = RichText(html: "<p>Test</p>")
            .backgroundColorHex("FF0000")
        if case .hex(let hex) = hexBg.configuration.backgroundColor {
            XCTAssertEqual(hex, "FF0000")
        } else {
            XCTFail("Background should be hex FF0000")
        }
        
        let colorBg = RichText(html: "<p>Test</p>")
            .backgroundColorSwiftUI(.blue)
        if case .color(_) = colorBg.configuration.backgroundColor {
            XCTAssertTrue(true)
        } else {
            XCTFail("Background should be SwiftUI color")
        }
    }
    
    @available(*, deprecated, message: "Testing backward compatibility")
    func testBackgroundColorBackwardCompatibility() {
        // Test deprecated String-based method still works - intentionally using deprecated methods
        let richText = RichText(html: "<p>Test</p>")
            .backgroundColor("transparent")
        
        if case .transparent = richText.configuration.backgroundColor {
            XCTAssertTrue(true)
        } else {
            XCTFail("Backward compatibility failed")
        }
        
        let hexRichText = RichText(html: "<p>Test</p>")
            .backgroundColor("#FF0000")
        
        if case .hex(let hex) = hexRichText.configuration.backgroundColor {
            let cleanHex = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
            XCTAssertTrue(cleanHex.contains("FF0000") || cleanHex == "FF0000")
        } else {
            XCTFail("Hex backward compatibility failed")
        }
    }
    
    func testBackgroundColorCSSGeneration() {
        XCTAssertEqual(BackgroundColor.transparent.cssValue, "transparent")
        XCTAssertEqual(BackgroundColor.system.cssValue, "inherit")
        XCTAssertEqual(BackgroundColor.hex("FF0000").cssValue, "#FF0000")
        XCTAssertEqual(BackgroundColor.hex("#FF0000").cssValue, "#FF0000") // Test # prefix handling
    }
    
    func testMediaClickHandling() {
        var clickedMedia: MediaClickType?
        
        let richText = RichText(html: "<img src='test.jpg'>")
            .onMediaClick { media in
                clickedMedia = media
            }
        
        XCTAssertNotNil(richText.configuration.mediaClickHandler)
        
        // Simulate media click
        richText.configuration.mediaClickHandler?(.image(src: "test.jpg"))
        
        if case .image(let src) = clickedMedia {
            XCTAssertEqual(src, "test.jpg")
        } else {
            XCTFail("Media click handler not working")
        }
    }
    
    func testErrorHandling() {
        var receivedError: RichTextError?
        
        let richText = RichText(html: "<p>Test</p>")
            .onError { error in
                receivedError = error
            }
        
        XCTAssertNotNil(richText.configuration.errorHandler)
        
        // Simulate error
        richText.configuration.errorHandler?(.htmlLoadingFailed("test html"))
        
        if case .htmlLoadingFailed(_) = receivedError {
            XCTAssertTrue(true)
        } else {
            XCTFail("Error handler not working")
        }
    }
    
    func testLoadingTransitions() {
        let fadeTransition = RichText(html: "<p>Test</p>")
            .loadingTransition(.fade)
        
        XCTAssertNotNil(fadeTransition.configuration.transition)
        
        let customTransition = RichText(html: "<p>Test</p>")
            .loadingTransition(.custom(.easeInOut))
        
        XCTAssertNotNil(customTransition.configuration.transition)
    }
    
    func testLoadingPlaceholder() {
        let richText = RichText(html: "<p>Test</p>")
            .loadingPlaceholder("Please wait...")
        
        XCTAssertNotNil(richText.placeholder)
    }
    
    func testPublicCSSGeneration() {
        let config = Configuration(
            lineHeight: 150,
            imageRadius: 8
        )
        
        let css = config.generateCompleteCSS()
        XCTAssertTrue(css.contains("border-radius: 8.0px"))
        XCTAssertTrue(css.contains("line-height: 150.0%"))
        
        let richText = RichText(html: "<p>Test</p>", configuration: config)
        let generatedCSS = richText.generateCSS()
        
        XCTAssertFalse(generatedCSS.isEmpty)
        XCTAssertTrue(generatedCSS.contains("border-radius: 8.0px"))
    }
    
    func testImprovedFontHandling() {
        let monoConfig = Configuration(fontType: .monospaced)
        let css = monoConfig.css(isLight: true, alignment: .leading)
        
        XCTAssertTrue(css.contains("monospace"))
        
        let italicConfig = Configuration(fontType: .italic)
        let italicCSS = italicConfig.css(isLight: true, alignment: .leading)
        
        XCTAssertTrue(italicCSS.contains("font-style: italic"))
    }
    
    func testHTML5ElementSupport() {
        let config = Configuration()
        let css = config.css(isLight: true, alignment: .leading)
        
        XCTAssertTrue(css.contains("figure"))
        XCTAssertTrue(css.contains("details"))
        XCTAssertTrue(css.contains("summary"))
        XCTAssertTrue(css.contains("figcaption"))
    }
    
    // MARK: - Performance Tests
    
    func testConfigurationPerformance() {
        measure {
            for _ in 0..<1000 {
                _ = Configuration()
            }
        }
    }
    
    func testColorSetPerformance() {
        measure {
            for _ in 0..<1000 {
                let colorSet = ColorSet(light: "FF0000", dark: "00FF00")
                _ = colorSet.value(true)
                _ = colorSet.value(false)
            }
        }
    }
    
    func testCSSGenerationPerformance() {
        let config = Configuration()
        measure {
            for _ in 0..<100 {
                _ = config.css(isLight: true, alignment: .leading)
                _ = config.css(isLight: false, alignment: .center)
            }
        }
    }
}
