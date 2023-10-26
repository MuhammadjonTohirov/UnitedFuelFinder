//
//  SearchField.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/10/23.
//

import Foundation
import SwiftUI

public struct YSearchField: View {
    @Binding var text: String
    
    public var body: some View {
        HStack {
            Image("icon_pin_search")
                .renderingMode(.template)
                .foregroundStyle(Color.label)
            YTextField(text: $text, placeholder: "Search")
        }
        .padding(8)
        .frame(height: 42)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.secondaryBackground)
        }
    }
}

#Preview {
    @State var text = ""
    return YSearchField(text: $text)
        .padding()
}
