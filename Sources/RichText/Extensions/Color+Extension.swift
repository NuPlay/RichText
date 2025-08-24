//
//  Color+Extension.swift
//
//
//  Created by Macbookator on 5.06.2022.
//

#if canImport(UIKit)
import UIKit

/// RGBA color components for precise color comparison
struct RGBAComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

extension UIColor {
    /// Converts UIColor to hex string for CSS usage
    var hex: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = RichTextConstants.colorMultiplier

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        } else {
            return String(
                format: "%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    /// Returns RGBA components for robust color comparison
    var rgba: RGBAComponents? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        return RGBAComponents(red: red, green: green, blue: blue, alpha: alpha)
    }
}
#else
import AppKit

/// RGBA color components for precise color comparison
struct RGBAComponents {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat
}

extension NSColor {
    /// Converts NSColor to hex string for CSS usage
    var hex: String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])

        return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
    
    /// Returns RGBA components for robust color comparison
    var rgba: RGBAComponents? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let alpha = components.count >= 4 ? CGFloat(components[3]) : 1.0
        
        return RGBAComponents(
            red: CGFloat(components[0]),
            green: CGFloat(components[1]),
            blue: CGFloat(components[2]),
            alpha: alpha
        )
    }
}
#endif
