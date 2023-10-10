//
//  YTextFieldCleanStyle.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct YTextFieldBackgroundCleanStyle: ViewModifier {
    public var padding: CGFloat = 0
    
    public init(padding: CGFloat = 0) {
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .background(
                RoundedRectangle(
                    cornerRadius: 10
                ).stroke(lineWidth: 1).foregroundStyle(
                    Color.init(uiColor: .placeholderText)
                )
            )
    }
}
