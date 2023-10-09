//
//  AuthView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI
import UnitedUIKit

struct AuthView: View {
    @State var username: String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(
                "welcome_to".localize.highlight(
                    text: "Fuel Finder",
                    color: .accent
                ).toSwiftUI
            )
            .font(.system(size: 24, weight: .semibold))
            .padding(.horizontal, Padding.medium)
            
            Text(
                "Let’s sign you in".localize
            )
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, Padding.medium)
            
            YTextField(
                text: $username,
                placeholder: "sample@domain.com",
                contentType: UITextContentType.emailAddress,
                autoCapitalization: .never,
                left: {
                    Image(systemName: "person.fill")
                        .padding(.trailing, Padding.small)
                }
            ).keyboardType(
                .emailAddress
            )
            .padding(.horizontal, Padding.small)
            .background(
                RoundedRectangle(
                    cornerRadius: 10
                ).stroke(lineWidth: 1).foregroundStyle(
                    Color.init(uiColor: .placeholderText)
                )
            )
            .padding(
                Padding.medium
            )
        }
    }
}


#Preview {
    AuthView()
}
