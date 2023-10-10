//
//  YTextFieldBottomInfo.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct YTextFieldBottomInfo: ViewModifier {
    var text: String
    var color: Color = Color("lite_blue")
    @State private var textOpacity: Double = 0
    
    public init(text: String, color: Color) {
        self.text = text
        self.color = color
        self.textOpacity = textOpacity
    }
    
    public func body(content: Content) -> some View {
        VStack(alignment: .trailing, spacing: 4) {
            content
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(color)
                .opacity(textOpacity)
        }.onAppear {
            withAnimation(.easeIn(duration: 0.2)) {
                textOpacity = text.isEmpty ? 0 : 1
            }
        }
    }
}
