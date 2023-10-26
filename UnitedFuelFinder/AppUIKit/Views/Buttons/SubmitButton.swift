//
//  SubmitButton.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import SwiftUI

public struct SubmitButton<Content: View>: View {
    var action: () -> Void
    var title: (() -> Content)?
    
    private(set) var isLoading: Bool = false
    private(set) var isEnabled: Bool = true
    public init(
        action: @escaping () -> Void,
        label: (() -> Content)?) {
        self.action = action
        self.title = label
    }
    
    public var body: some View {
        Button(
            action: {
                (isLoading || !isEnabled) ? () : action()
            },
            label: {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .foregroundStyle(Color.accentColor)
                    .overlay {
                        if let t = title?() {
                            t
                        }
                    }
            }
        )
        .overlay(content: {
            Rectangle()
                .foregroundStyle(
                    Color.white.opacity((isLoading || !isEnabled) ? 0.4 : 0)
                )
                .overlay {
                    HStack {
                        Spacer()
                        
                        ProgressView()
                            .foregroundStyle(Color.white)
                            .opacity(isLoading ? 1 : 0)
                    }
                    .padding(.horizontal, Padding.medium)
                }
        })
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.white)
        .frame(height: 50, alignment: .center)
        .frame(maxWidth: .infinity)
    }
    
    public func set(isLoading: Bool) -> Self {
        var v = self
        v.isLoading = isLoading
        return v
    }
    
    public func set(isEnabled: Bool) -> Self {
        var v = self
        v.isEnabled = isEnabled
        return v
    }
}

#Preview {
    SubmitButton {
        
    } label: {
        Text("Show")
    }
    .set(isLoading: true)
    
}
