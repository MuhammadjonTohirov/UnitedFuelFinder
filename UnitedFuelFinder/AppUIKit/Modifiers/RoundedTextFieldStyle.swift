//
//  YTextFieldCleanStyle.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct RoundedTextFieldStyle: ViewModifier {
    var padding: CGFloat = 0
    var radius: CGFloat = 8
    var borderColor: Color = .init(uiColor: .placeholderText)
    public init(padding: CGFloat = 0, radius: CGFloat = 8) {
        self.padding = padding
        self.radius = radius
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background(
                RoundedRectangle(
                    cornerRadius: radius
                )
                .stroke(lineWidth: 1).foregroundStyle(
                    borderColor
                )
                .padding(.horizontal, 1)
            )
    }
    
    public func set(borderColor: Color) -> Self {
        var v = self
        v.borderColor = borderColor
        return v
    }
}
