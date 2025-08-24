//
//  ColorSet.swift
//  
//
//  Created by 이웅재(NuPlay) on 2022/01/04.
//  https://github.com/NuPlay/RichText

import SwiftUI

/// A structure that holds color values for both light and dark modes
/// 
/// ColorSet allows you to define different colors for light and dark appearances,
/// with optional CSS !important enforcement for overriding HTML styles.
///
/// ## Example Usage
/// ```swift
/// let textColors = ColorSet(light: "000000", dark: "FFFFFF", isImportant: true)
/// let linkColors = ColorSet(light: Color.blue, dark: Color.cyan)
/// ```
public struct ColorSet: Equatable {
    /// Hex color value for light mode (without # prefix)
    private let light: String
    /// Hex color value for dark mode (without # prefix)
    private let dark: String
    /// Whether to enforce this color with CSS !important
    public var isImportant: Bool

    /// Initializes a ColorSet with hex color strings
    /// - Parameters:
    ///   - light: Hex color for light mode (without # prefix)
    ///   - dark: Hex color for dark mode (without # prefix)
    ///   - isImportant: Whether to add CSS !important (default: false)
    public init(light: String, dark: String, isImportant: Bool = false) {
        self.light = light
        self.dark = dark
        self.isImportant = isImportant
    }

    #if canImport(UIKit)
    /// Initializes a ColorSet with UIColor objects (iOS/tvOS)
    /// - Parameters:
    ///   - light: UIColor for light mode
    ///   - dark: UIColor for dark mode
    ///   - isImportant: Whether to add CSS !important (default: false)
    public init(light: UIColor, dark: UIColor, isImportant: Bool = false) {
         self.light = light.hex ?? RichTextConstants.defaultLightColor
         self.dark = dark.hex ?? RichTextConstants.defaultDarkColor
         self.isImportant = isImportant
    }
    #else
    /// Initializes a ColorSet with NSColor objects (macOS)
    /// - Parameters:
    ///   - light: NSColor for light mode
    ///   - dark: NSColor for dark mode
    ///   - isImportant: Whether to add CSS !important (default: false)
    public init(light: NSColor, dark: NSColor, isImportant: Bool = false) {
         self.light = light.hex ?? RichTextConstants.defaultLightColor
         self.dark = dark.hex ?? RichTextConstants.defaultDarkColor
         self.isImportant = isImportant
    }
    #endif

    /// Returns the appropriate color value for the specified mode
    /// - Parameter isLight: Whether to return the light mode color
    /// - Returns: CSS color value with optional !important
    func value(_ isLight: Bool) -> String {
        "#\(isLight ? light : dark)\(isImportant ? " !important" : "")"
    }
    
    /// Robust color equality comparison based on RGBA values
    /// - Parameters:
    ///   - lhs: First ColorSet to compare
    ///   - rhs: Second ColorSet to compare
    /// - Returns: true if both light and dark colors match with same importance
    public static func == (lhs: ColorSet, rhs: ColorSet) -> Bool {
        return lhs.light.lowercased() == rhs.light.lowercased() &&
               lhs.dark.lowercased() == rhs.dark.lowercased() &&
               lhs.isImportant == rhs.isImportant
    }
    
    /// Returns the raw hex values without CSS formatting
    /// - Parameter isLight: Whether to return the light mode color
    /// - Returns: Raw hex color string without # prefix
    public func rawValue(_ isLight: Bool) -> String {
        isLight ? light : dark
    }
    
    /// Validates if the hex color strings are valid
    /// - Returns: true if both light and dark hex values are valid
    public var isValid: Bool {
        return isValidHexColor(light) && isValidHexColor(dark)
    }
    
    private func isValidHexColor(_ hex: String) -> Bool {
        let hexRegex = "^[0-9A-Fa-f]{6}$|^[0-9A-Fa-f]{8}$" // 6 or 8 characters
        let predicate = NSPredicate(format: "SELF MATCHES %@", hexRegex)
        return predicate.evaluate(with: hex)
    }
}
