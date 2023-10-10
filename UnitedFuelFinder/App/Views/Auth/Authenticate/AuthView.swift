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
    @StateObject var viewModel: AuthorizationViewModel = .init()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Spacer()
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
                text: $viewModel.username,
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
            .modifier(YTextFieldBackgroundCleanStyle())
            .padding(
                Padding.medium
            )
            
            CheckButton(
                isSelected: $viewModel.isOfferAccepted,
                text: "auth_agree_offer".localize.highlight(
                    text: "auth_offer".localize,
                    color: .accent
                ).toSwiftUI
            ) {
                debugPrint("Show offer")
            }
            .padding(.horizontal, Padding.medium)
            
            Spacer()
            
            SubmitButton {
                viewModel.showOtp()
            } label: {
                Text("login".localize)
            }
            .padding()

        }.fullScreenCover(isPresented: $viewModel.showOTPConfirm) {
            if let vm = viewModel.otpViewModel {
                ZStack {
                    OTPView(viewModel: vm)
                }
            }
        }
    }
}


#Preview {
    AuthView()
}
