//
//  UIColor+Extension.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI
import UIKit

public extension Color {
    static var label: Color {
        .init(uiColor: .label)
    }
    
    static var background: Color {
        .init(uiColor: .systemBackground)
    }
    
    static var secondaryBackground: Color {
        .init(uiColor: .secondarySystemBackground)
    }
    
    static var tertiaryBackground: Color {
        .init(uiColor: .tertiarySystemBackground)
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let scanner = Scanner(string: hexString)
        
        if hexString.hasPrefix("#") {
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
        }
        
        var color: UInt64 = 0
        
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue = CGFloat(b) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
