//
//  NSColor+Hex.swift
//
//
//  Created by 이웅재 on 2023/09/17.
//

#if canImport(AppKit)
import AppKit

extension NSColor: ColorHexRepresentable {
    var cgComponents: [CGFloat]? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        return components
    }
}
#endif
