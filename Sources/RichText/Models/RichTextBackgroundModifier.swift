import SwiftUI

@available(iOS 14.0, *)
extension RichText {
    /// Applies a background color to the content via CSS. `.clear` becomes "transparent", others are hex.
    public func richTextBackground(_ color: Color) -> RichText {
        var result = self
        let cssColor = Self.cssString(from: color)
        // Add or update background-color in customCSS
        if result.configuration.customCSS.contains("background-color:") {
            // Replace previous background-color if it exists
            result.configuration.customCSS = result.configuration.customCSS.replacingOccurrences(of: #"background-color:.*?;"#, with: "background-color: \(cssColor);", options: .regularExpression)
        } else {
            result.configuration.backgroundColor = cssColor
        }
        return result
    }
    
    /// Helper to convert Color to CSS string.
    static func cssString(from color: Color) -> String {
        #if canImport(UIKit)
        if color == .clear { return "transparent" }
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02lX%02lX%02lX", Int(red * 255), Int(green * 255), Int(blue * 255))
        #else
        if color == .clear { return "transparent" }
        let nsColor = NSColor(color)
        let red = Int((nsColor.redComponent * 255).rounded())
        let green = Int((nsColor.greenComponent * 255).rounded())
        let blue = Int((nsColor.blueComponent * 255).rounded())
        return String(format: "#%02lX%02lX%02lX", red, green, blue)
        #endif
    }
}
