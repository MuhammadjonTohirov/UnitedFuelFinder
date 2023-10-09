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
    
    public init(
        action: @escaping () -> Void,
        label: (() -> Content)?) {
        self.action = action
        self.title = label
    }
    
    public var body: some View {
        Button(
            action: action,
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
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.white)
        .frame(height: 50, alignment: .center)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    SubmitButton {
        
    } label: {
        Text("Show")
    }
    
}
