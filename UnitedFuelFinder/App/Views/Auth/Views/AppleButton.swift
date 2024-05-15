//
//  AppleButton.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI

struct AppleButton: View {
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "apple.logo")
                .padding(.leading, 10)
            Text("Sign in with Apple")
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 64)
        }
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 20.f.sh())
                .foregroundStyle(Color.appBlack)
        }
    }
}
