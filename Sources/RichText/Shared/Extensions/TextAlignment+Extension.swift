//
//  TextAlignment+Extension.swift
//  
//
//  Created by MacBookator on 18.05.2022.
//

import SwiftUI

public extension TextAlignment {
    var htmlDescription: String {
        switch self {
        case .center:
            return "center"
        case .leading:
            return "left"
        case .trailing:
            return "right"
        }
    }
}
