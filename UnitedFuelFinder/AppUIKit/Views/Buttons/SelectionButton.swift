//
//  SelectionButton.swift
//  UnitedUIKit
//
//  Created by applebro on 24/10/23.
//

import Foundation
import SwiftUI

public struct SelectionButton: View {
    var title: String
    var value: String
    var onClick: () -> Void
    public init(title: String, value: String, onClick: @escaping () -> Void) {
        self.title = title
        self.value = value
        self.onClick = onClick
    }
    
    public var body: some View {
        Button(action: onClick) {
            innerBody
        }
    }
    
    public var innerBody: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .regular))
            Spacer()
            Text(value)
                .font(.system(size: 13, weight: .medium))
                .padding(.trailing, 4)
                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
            
            Image(systemName: "chevron.right")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 16)
        }
        .foregroundStyle(Color.label)
        .frame(height: 50)
        .padding(.horizontal, Padding.medium)
        .modifier(
            RoundedTextFieldStyle()
                .set(borderColor: Color.init(uiColor: .placeholderText))
        )
    }
}


#Preview {
    SelectionButton(title: "States", value: "Uzbekistan") {
        
    }
}
