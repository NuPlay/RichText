//
//  ColorSet.swift
//  
//
//  Created by 이웅재(NuPlay) on 2022/01/04.
//  https://github.com/NuPlay/RichText

import SwiftUI

public struct ColorSet {
    private let light: Color
    private let dark: Color
    public var isImportant: Bool

    public init(light: String, dark: String, isImportant: Bool = false) {
        self.light = Color(hex: light)
        self.dark = Color(hex: dark)
        self.isImportant = isImportant
    }

    public init(light: Color, dark: Color, isImportant: Bool = false) {
        self.light = light
        self.dark = dark
        self.isImportant = isImportant
    }
    
    func value(_ isLight: Bool) -> String {
        "#\(isLight ? light : dark)\(isImportant ? " !important" : "")"
    }
}
