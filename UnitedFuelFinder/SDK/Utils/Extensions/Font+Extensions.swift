//
//  Font+Extenstions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/07/24.
//

import Foundation
import SwiftUI

private func _fontName(weight: Font.Weight) -> String? {
    switch weight {
    case .regular:
        return "Lato-Regular"
    case .bold:
        return "Lato-Bold"
    case .light:
        return "Lato-Light"
    case .thin:
        return "Lato-Thin"
    case .ultraLight:
        return "Lato-Thin"
    case .medium:
        return "Lato-Regular"
    case .semibold:
        return "Lato-Bold"
    case .heavy:
        return "Lato-Black"
    case .black:
        return "Lato-Black"
    default:
        return nil
    }
}

extension Font {
    static func lato(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design? = nil) -> Font {
        if let name = _fontName(weight: weight) {
            return Font.custom(name, fixedSize: size)
        }
        
        return Font.lato(size: size, weight: weight, design: design)
    }
}

extension UIFont {
    static func lato(ofSize size: CGFloat, weight: Font.Weight = .regular, design: Font.Design? = nil) -> UIFont {
        if let name = _fontName(weight: weight) {
            return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
        }
        
        return UIFont.systemFont(ofSize: size)
    }
}
