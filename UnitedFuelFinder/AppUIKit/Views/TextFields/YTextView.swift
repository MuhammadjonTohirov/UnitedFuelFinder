//
//  YTextView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/11/23.
//

import Foundation
import SwiftUI

public struct YTextView: View {
    @Binding public var text: String
    public var placeholder: String
    public var lineLimit: Int = 5
    @FocusState private var isFocused: Bool
    
    public var body: some View {
        TextField("", text: $text, prompt: Text(placeholder), axis: .vertical)
            .padding(Padding.medium)
            .textContentType(.streetAddressLine1)
            .font(Font.lato(size: 14, weight: .regular))
            .lineLimit(lineLimit, reservesSpace: true)
            .background(
                RoundedRectangle(
                    cornerRadius: 8
                )
                .stroke(lineWidth: 1).foregroundStyle(
                    isFocused ? Color.black.opacity(0.8) : Color.gray.opacity(0.5)
                )
                .padding(.horizontal, 1)
            )
            .focused($isFocused)
    }
}
