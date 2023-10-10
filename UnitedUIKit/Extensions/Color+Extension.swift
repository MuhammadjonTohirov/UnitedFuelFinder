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
