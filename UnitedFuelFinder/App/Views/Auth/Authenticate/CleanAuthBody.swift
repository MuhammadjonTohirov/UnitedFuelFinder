//
//  CleanAuthBody.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI

struct CleanAuthBody: View {
    @EnvironmentObject var viewModel: AuthorizationViewModel
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(
                    "welcome_to".localize.highlight(
                        text: "Fuel Finder",
                        color: .accent
                    ).toSwiftUI
                )
                .font(.lato(size: 24, weight: .semibold))
                .padding(.horizontal, Padding.medium)
                .padding(.bottom, Padding.medium)
                
                Text(
                    "lets_sign_in_you".localize
                )
                .font(.lato(size: 14, weight: .semibold))
                .padding(.horizontal, Padding.medium)
                
                VStack(spacing: 10) {
                    form
                }
                .padding(.bottom, Padding.large.sh())
            }
            
            VStack {
                Spacer()
                SubmitButton(action: {
                    viewModel.onClickRegister()
                }, label: {
                    Text("no.account".localize)
                        .foregroundStyle(Color.accentColor)
                }, backgroundColor: .clear)
                .padding(.horizontal, Padding.default)

                SubmitButton {
                    viewModel.onClickAuthenticate()
                } label: {
                    Text("authenticate".localize)
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
            .background(.appBackground)
    }
    
    @ViewBuilder
    private var form: some View {
        YRoundedTextField {
            YTextField(
                text: $viewModel.username,
                placeholder: "sample@domain.com",
                contentType: UITextContentType.emailAddress,
                autoCapitalization: .never,
                left: {
                    Icon(systemName: "person.fill")
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
            .keyboardType(.emailAddress)
        }
        .set(error: viewModel.emailError ?? "")
        .padding(
            .horizontal, Padding.medium
        )
        
        YRoundedTextField {
            YTextField(
                text: $viewModel.password,
                placeholder: "••••••••",
                isSecure: true,
                contentType: UITextContentType.password,
                autoCapitalization: .never,
                left: {
                    Image("jcon_key")
                        .renderingMode(.template)
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
            .keyboardType(.default)
        }
        .padding(
            .horizontal, Padding.medium
        )
    }
}
