//
//  RichTextEnums.swift
//
//
//  Created by 이웅재(NuPlay) on 2021/07/26.
//  https://github.com/NuPlay/RichText

import Foundation
import SafariServices
import SwiftUI

/// Defines the font types available for text rendering
public enum FontType {
    /// System font (default)
    case system
    /// Monospaced system font
    case monospaced
    /// Italic system font
    case italic
    #if canImport(UIKit)
    /// Custom UIFont (iOS/tvOS only)
    case custom(UIFont)
    #endif
    /// Custom font by name
    case customName(String)

    @available(*, deprecated, renamed: "system")
    case `default`
    
    /// Returns the font name string for CSS usage
    var name: String {
        switch self {
        case .monospaced:
            return "ui-monospace, 'SF Mono', Consolas, 'Liberation Mono', Menlo, Courier, monospace"
        case .italic:
            return "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
        #if canImport(UIKit)
        case let .custom(font):
            return "'\(font.fontName)'"
        #endif
        case let .customName(name):
            return "'\(name)'"
        default:
            return RichTextConstants.systemFontName
        }
    }
    
    /// Returns additional CSS properties for the font type
    var additionalCSSProperties: String {
        switch self {
        case .italic:
            return "font-style: italic;"
        case .monospaced:
            return "font-variant-numeric: tabular-nums;"
        default:
            return ""
        }
    }
}

/// Defines how links should be opened when tapped
public enum LinkOpenType {
    #if canImport(UIKit)
    /// Open in SFSafariViewController with optional configuration
    case SFSafariView(configuration: SFSafariViewController.Configuration = .init(), isReaderActivated: Bool? = nil, isAnimated: Bool = true)
    #endif
    /// Open in system Safari browser
    case Safari
    /// Custom link handling with closure
    case custom((URL) -> Void)
    /// Don't handle link taps
    case none
}

/// Defines media click event types
public enum MediaClickType {
    case image(src: String)
    case video(src: String)
}

/// Media event handler type
public typealias MediaClickHandler = (MediaClickType) -> Void

/// RichText error types
public enum RichTextError: LocalizedError {
    case htmlLoadingFailed(String)
    case webViewConfigurationFailed
    case cssGenerationFailed
    case mediaHandlingFailed(String)
    
    public var errorDescription: String? {
        switch self {
        case .htmlLoadingFailed(let html):
            return "Failed to load HTML content: \(html.prefix(100))..."
        case .webViewConfigurationFailed:
            return "Failed to configure WebView properly"
        case .cssGenerationFailed:
            return "Failed to generate CSS styles"
        case .mediaHandlingFailed(let media):
            return "Failed to handle media click for: \(media)"
        }
    }
}

/// Error handler type
public typealias ErrorHandler = (RichTextError) -> Void

/// Defines which colors should be enforced with CSS !important
public enum ColorPreference: Equatable {
    /// Force all colors (text and links)
    case all
    /// Force only link colors
    case onlyLinks
    /// Don't force any colors
    case none
}

/// Defines the color scheme for RichText content
public enum RichTextColorScheme: Equatable {
    /// Always light mode
    case light
    /// Always dark mode
    case dark
    /// Automatic based on system preference
    case auto
}

// MARK: - Backward Compatibility

/// Backward compatibility alias for RichTextColorScheme
/// - Note: Deprecated in favor of RichTextColorScheme to avoid conflicts with SwiftUI.ColorScheme
@available(*, deprecated, renamed: "RichTextColorScheme", message: "Use RichTextColorScheme instead to avoid conflicts with SwiftUI.ColorScheme")
public typealias ColorScheme = RichTextColorScheme

/// Defines background color options for RichText
public enum BackgroundColor: Equatable {
    /// Transparent background (default for easy use)
    case transparent
    /// System default background (white/black based on scheme)
    case system
    /// Custom hex color (without # prefix)
    case hex(String)
    /// SwiftUI Color
    case color(Color)
    
    public static func == (lhs: BackgroundColor, rhs: BackgroundColor) -> Bool {
        switch (lhs, rhs) {
        case (.transparent, .transparent), (.system, .system):
            return true
        case (.hex(let lhsHex), .hex(let rhsHex)):
            return lhsHex == rhsHex
        case (.color(let lhsColor), .color(let rhsColor)):
            return compareColors(lhsColor, rhsColor)
        default:
            return false
        }
    }
    
    /// Compares two SwiftUI Colors using their RGBA values
    /// - Parameters:
    ///   - lhs: First color to compare
    ///   - rhs: Second color to compare
    /// - Returns: True if colors have the same RGBA values
    private static func compareColors(_ lhs: Color, _ rhs: Color) -> Bool {
        #if canImport(UIKit)
        guard let lhsUIColor = UIColor(lhs).rgba,
              let rhsUIColor = UIColor(rhs).rgba else {
            return false
        }
        return abs(lhsUIColor.red - rhsUIColor.red) < 0.001 &&
               abs(lhsUIColor.green - rhsUIColor.green) < 0.001 &&
               abs(lhsUIColor.blue - rhsUIColor.blue) < 0.001 &&
               abs(lhsUIColor.alpha - rhsUIColor.alpha) < 0.001
        #else
        guard let lhsNSColor = NSColor(lhs).rgba,
              let rhsNSColor = NSColor(rhs).rgba else {
            return false
        }
        return abs(lhsNSColor.red - rhsNSColor.red) < 0.001 &&
               abs(lhsNSColor.green - rhsNSColor.green) < 0.001 &&
               abs(lhsNSColor.blue - rhsNSColor.blue) < 0.001 &&
               abs(lhsNSColor.alpha - rhsNSColor.alpha) < 0.001
        #endif
    }
    
    /// Returns the CSS value for the background color
    var cssValue: String {
        switch self {
        case .transparent:
            return "transparent"
        case .system:
            return "inherit"
        case .hex(let hexValue):
            let cleanHex = hexValue.hasPrefix("#") ? String(hexValue.dropFirst()) : hexValue
            return "#\(cleanHex)"
        case .color(let color):
            #if canImport(UIKit)
            if #available(iOS 14.0, *), let hex = UIColor(color).hex {
                return "#\(hex)"
            }
            #else
            if #available(macOS 11.0, *), let hex = NSColor(color).hex {
                return "#\(hex)"
            }
            #endif
            return "transparent"
        }
    }
}

/// Defines loading state transitions
public enum LoadingTransition {
    /// No transition
    case none
    /// Fade transition
    case fade
    /// Slide transition
    case slide
    /// Scale transition
    case scale
    /// Custom animation
    case custom(Animation)
    
    var animation: Animation? {
        switch self {
        case .none:
            return nil
        case .fade:
            return .easeInOut(duration: 0.3)
        case .slide:
            return .easeInOut(duration: 0.4)
        case .scale:
            return .spring(response: 0.5, dampingFraction: 0.8)
        case .custom(let animation):
            return animation
        }
    }
}


