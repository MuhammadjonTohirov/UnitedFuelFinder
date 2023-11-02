//
//  YRoundedTextField.swift
//  UnitedUIKit
//
//  Created by applebro on 12/10/23.
//

import Foundation
import SwiftUI

public struct YRoundedTextField<Content: TextFieldProtocol>: View {
    @FocusState var isFocused: Bool
    var textField: () -> Content
    var onFocusChanged: ((Bool) -> Void)?
    private var errorText: String = ""
    
    var hasError: Bool {
        !errorText.isEmpty
    }
    
    var borderColor: Color {
        if hasError && !isFocused {
            return .init(.systemRed)
        }
        
        return isFocused ? .secondary : .init(uiColor: .placeholderText).opacity(0.5)
    }
    
    public init(
        focused: Bool = false,
        textField: @escaping () -> Content
    ) {
        self.textField = textField
        self.isFocused = focused
    }
    
    public var body: some View {
        VStack(alignment: .trailing) {
            textField()
                .padding(.horizontal, Padding.small)
                .onTapGesture {
                    isFocused = true
                }
                .modifier(
                    YTextFieldBorderStyle()
                        .set(borderColor: borderColor)
                )
                .focused($isFocused)
                .onChange(of: isFocused) { val in
                    onFocusChanged?(val)
                }
            
            if hasError {
                Text(errorText)
                    .font(.system(size: 12))
                    .foregroundStyle(borderColor)
            }
        }
    }
    
    public func set(error: String) -> some View {
        var v = self
        v.errorText = error
        return v
    }
    
    public func set(onFocusChanged: @escaping (Bool) -> Void) -> some View {
        var v = self
        v.onFocusChanged = onFocusChanged
        return v
    }
}

#Preview {
    @State var text: String = ""
    return YRoundedTextField(textField: {
        YTextField(text: $text, placeholder: "Placeholder", left: {
            Image(systemName: "touchid").padding(.trailing, 4)
        })
    }).set(error: "Invalid email")
}
