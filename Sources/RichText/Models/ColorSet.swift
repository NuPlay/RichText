//
//  ColorSet.swift
//  
//
//  Created by 이웅재(NuPlay) on 2022/01/04.
//  https://github.com/NuPlay/RichText

import SwiftUI

public struct ColorSet {
    private let light: String
    private let dark: String
    public var isImportant: Bool

    public init(light: String, dark: String, isImportant: Bool = false) {
        self.light = light
        self.dark = dark
        self.isImportant = isImportant
    }

    #if canImport(UIKit)
    public init(light: UIColor, dark: UIColor, isImportant: Bool = false) {
         self.light = light.hex ?? "000000"
         self.dark = dark.hex ?? "F2F2F2"
         self.isImportant = isImportant
    }
    #else
    public init(light: NSColor, dark: NSColor, isImportant: Bool = false) {
         self.light = light.hex ?? "000000"
         self.dark = dark.hex ?? "F2F2F2"
         self.isImportant = isImportant
    }
    #endif

    func value(_ isLight: Bool) -> String {
        "#\(isLight ? light : dark)\(isImportant ? " !important" : "")"
    }
}
