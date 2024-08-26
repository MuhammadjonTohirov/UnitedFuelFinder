//
//  DarkAuthBody.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI

struct DarkAuthBody: View {
    @EnvironmentObject var viewModel: AuthorizationViewModel
    @State var showAlert: Bool = false
    @State var alert: AlertToast = .init(type: .regular)
    @State private var bottomRect: CGRect = .zero
    @State private var bodyRect: CGRect = .zero
    @State private var formRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            headerImage
                .vertical(alignment: .top)
                .readRect(rect: $bodyRect)
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                Text(
                    "lets_sign_in_you".localize
                )
                .font(.lato(size: 24, weight: .semibold))
                .padding(.horizontal, Padding.medium.sh())
                .padding(.bottom, Padding.default.sh() * 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                form
                    .frame(height: 152)
                    .padding(.bottom, Padding.large.sh())
                
            }
            .readRect(rect: $formRect)
            .padding(.top, (bodyRect.height / 2 - bottomRect.height - formRect.height / 2))
            
            VStack {
                SubmitButton {
                    viewModel.onClickAuthenticate()
                } label: {
                    Text("authenticate".localize)
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.horizontal, Padding.default.sh())
                .padding(.bottom, Padding.medium.sh())

                SubmitButton(action: {
                    viewModel.onClickRegister()
                }, label: {
                    Text("no.account".localize)
                        .foregroundStyle(Color.accentColor)
                }, backgroundColor: .clear) 
                .padding(.horizontal, Padding.default.sh())
                .padding(.bottom, Padding.default.sh())
                
                AppleButton()
                    .onTapGesture {
                        showToast("coming_soon".localize)
                    }
                    .padding(.bottom, Padding.medium.sh())
                    .set(isVisible: false)
            }
            .readRect(rect: $bottomRect)
            .vertical(alignment: .bottom)
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .foregroundStyle(.white)
        .background(Color.appDarkGray)
        .toast($showAlert, self.alert, duration: 2)
    }
    
    private var form: some View {
        VStack(spacing: 10.f.sh()) {
            YRoundedTextField(radius: 32) {
                YTextField(
                    text: $viewModel.username,
                    placeholder: "sample@domain.com",
                    placeholderColor: .white.opacity(0.5),
                    autoCapitalization: .never,
                    left: {
                        Icon(systemName: "person.fill")
                            .size(.init(width: 18, height: 18))
                            .iconColor(.white)
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small.sh())
                    }
                )
                .keyboardType(.default)
            }
            .set(error: viewModel.emailError ?? "")
            .background(
                // rounded view with black background
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.appBlack)
            )
            .padding(
                .horizontal, Padding.medium.sh()
            )
            .padding(.bottom, 8)

            YRoundedTextField(radius: 32) {
                YTextField(
                    text: $viewModel.password,
                    placeholder: "••••••••",
                    placeholderColor: .white.opacity(0.5),
                    isSecure: true,
                    autoCapitalization: .never,
                    left: {
                        Image("jcon_key")
                            .renderingMode(.template)
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small.sh  ())
                    }
                )
                .keyboardType(.default)
            }
            .background(
                // rounded view with black background
                RoundedRectangle(cornerRadius: 32)
                    .fill(Color.appBlack)
            )

            .padding(
                .horizontal, Padding.medium.sh()
            )
            .padding(.bottom, 8)
            .ignoresSafeArea(.keyboard, edges: .bottom)

        }
    }
    
    private func showToast(_ message: String) {
        self.alert = .init(displayMode: .alert, type: .regular, title: message)
        self.showAlert = true
    }
    
    private var headerImage: some View {
        Image("image_driver")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIApplication.shared.screenFrame.width, height: 322.f.sh())
    }
}
