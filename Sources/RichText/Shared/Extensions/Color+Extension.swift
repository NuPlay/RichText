//
//  Color+Extension.swift
//
//
//  Created by Macbookator on 5.06.2022.
//

import CoreGraphics

protocol ColorHexRepresentable {
    var cgComponents: [CGFloat]? { get }
    var hex: String? { get }
}

extension ColorHexRepresentable {
    var hex: String? {
        guard let components = cgComponents, components.count >= 3 else {
            return nil
        }

        let r = CGFloat(components[0])
        let g = CGFloat(components[1])
        let b = CGFloat(components[2])

        return String(format: "%02lX%02lX%02lX", lround(Double(r * 255)), lround(Double(g * 255)), lround(Double(b * 255)))
    }
}
