//
//  AuthView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthorizationViewModel = .init()
    @State var showAlert: Bool = false
    
    var body: some View {
        mainBody
    }
    
    private var mainBody: some View {
        NavigationStack {
            innerBody
                .keyboardDismissable()
                .alert("warning".localize,
                       isPresented: $viewModel.shouldShowAlert,
                       actions: {
                    Button("ok".localize.uppercased()) {
                        viewModel.hideAlert()
                    }
                }, message: {
                    Text(viewModel.alert.title ?? "")
                })
                .navigationDestination(isPresented: $viewModel.present) {
                    viewModel.route?.screen
                        .background(.appBackground)
                }
                .background(.appBackground)
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    private var innerBody: some View {
        ZStack {
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
                    "lets_sign_in_you".localize
                )
                .font(.system(size: 14, weight: .semibold))
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
                    Image(systemName: "person.fill")
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
        
//        HStack {
//            Spacer()
//            
//            Button(action: {
//                viewModel.route = .forgotpassword
//            }, label: {
//                Text("forgot.password".localize)
//                    .font(.system(size: 13, weight: .medium))
//            })
//            .padding(.horizontal, Padding.default)
//            .padding(.top, Padding.small)
//        }
    }
}


#Preview {
    AuthView()
}
