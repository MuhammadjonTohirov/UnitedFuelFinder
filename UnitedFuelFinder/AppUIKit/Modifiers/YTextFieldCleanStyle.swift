//
//  YTextFieldCleanStyle.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct YTextFieldBorderStyle: ViewModifier {
    var padding: CGFloat = 0
    var borderColor: Color = .init(uiColor: .placeholderText)
    public init(padding: CGFloat = 0) {
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background(
                RoundedRectangle(
                    cornerRadius: 8
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
