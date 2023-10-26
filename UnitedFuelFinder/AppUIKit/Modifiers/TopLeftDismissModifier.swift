//
//  TopLeftDismissModifier.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct TopLeftDismissModifier: ViewModifier {
    @Environment(\.dismiss) var dismiss
    var onDismiss: (() -> Void)? = nil
    
    public init(onDismiss: @escaping () -> Void) {
        self.onDismiss = onDismiss
    }
    
    public init() {
        
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            Button {
                dismiss()
                onDismiss?()
            } label: {
                Image(systemName: "xmark")
                    .frame(width: 20, height: 20)
                    .fixedSize()
                    .foregroundStyle(Color.label)
            }
            .zIndex(1)
            .frame(width: 20, height: 20)
            .position(x: Padding.large, y: Padding.large)
            
            content
        }
    }
}
