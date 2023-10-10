//
//  CheckButton.swift
//  UnitedUIKit
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public struct CheckButton: View {
    @Binding var isSelected: Bool
    var text: AttributedString
    
    var onClickText: (() -> Void)
    
    public init(
        isSelected: Binding<Bool>,
        text: AttributedString,
        onClickText: @escaping () -> Void
    ) {
        self._isSelected = isSelected
        self.text = text
        self.onClickText = onClickText
    }
    
    
    
    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Image(systemName: isSelected ? "checkmark.square" : "square")
                .foregroundColor(.accentColor)
                .font(.system(size: 20, weight: .bold))
                .onTapGesture {
                    isSelected.toggle()
                }
        
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .onTapGesture(perform: onClickText)
        }
    }
}
