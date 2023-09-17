//
//  UIColor+Hex.swift
//
//
//  Created by 이웅재 on 2023/09/17.
//

#if canImport(UIKit)
import UIKit

extension UIColor: ColorHexRepresentable {
    var cgComponents: [CGFloat]? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        return [red, green, blue]
    }
}
#endif
