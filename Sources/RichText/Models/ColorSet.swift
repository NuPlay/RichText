//
//  ColorSet.swift
//  
//
//  Created by 이웅재(NuPlay) on 2022/01/04.
//  https://github.com/NuPlay/RichText

import SwiftUI

public struct ColorSet {
    var light: String
    var dark: String

    public init(light: String, dark: String) {
        self.light = light
        self.dark = dark
    }
}
