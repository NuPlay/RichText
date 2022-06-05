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
    
    @available(iOS 14.0, *)
    public init(light: Color, dark: Color, isImportant: Bool = false) {
        self.light = UIColor(light).hex ?? "000000"
        self.dark = UIColor(dark).hex ?? "F2F2F2"
        self.isImportant = isImportant
    }
    
    public init(light: UIColor, dark: UIColor, isImportant: Bool = false) {
        self.light = light.hex ?? "000000"
        self.dark = dark.hex ?? "F2F2F2"
        self.isImportant = isImportant
    }
    
    func value(_ isLight: Bool) -> String {
        "#\(isLight ? light : dark)\(isImportant ? " !important" : "")"
    }
}
