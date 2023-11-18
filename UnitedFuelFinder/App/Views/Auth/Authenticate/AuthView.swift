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
                }
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
                
                VStack(alignment: .leading) {
                    YRoundedTextField {
                        YTextField(
                            text: $viewModel.username,
                            placeholder: "sample@domain.com",
                            contentType: UITextContentType.emailAddress,
                            autoCapitalization: .never,
                            left: {
                                Image(systemName: "person.fill")
                                    .padding(.trailing, Padding.small)
                            }
                        )
                        .keyboardType(
                            .emailAddress
                        )
                    }
                    .padding(
                        .horizontal, Padding.medium
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
                    .padding(.top, Padding.small / 2)
                    .padding(.bottom, Padding.large)
                }
            }
            
            VStack {
                Spacer()
                SubmitButton {
                    viewModel.onClickVerifyUsername()
                } label: {
                    Text("authenticate".localize)
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isOfferAccepted && !viewModel.username.isEmpty)
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
    }
}


#Preview {
    AuthView()
}
