//
//  SelectLanguageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI

struct SelectLanguageView: View {
    var body: some View {
        VStack(spacing: 40) {
            Text("English")
            Text("O'zbekcha")
            Text("Русский")
        }
        .padding()
    }
}

#Preview {
    SelectLanguageView()
}
