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
    
    var body: some View {
        ZStack {
            VStack {
                headerImage
                    .overlay {
                        Text("driver".localize)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                    }
                    .ignoresSafeArea()
                    
                Spacer()
            }
            
            VStack(alignment: .center) {
                Spacer()
                
                Text(
                    "lets_sign_in_you".localize
                )
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal, Padding.medium.sh())
                .padding(.bottom, Padding.default.sh() * 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                form
                    .padding(.bottom, Padding.large.sh())
                    .ignoresSafeArea(.keyboard, edges: .bottom)

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
                .padding(.bottom, Padding.small.sh())
                .ignoresSafeArea()
                
                AppleButton()
                    .padding(.bottom, Padding.medium.sh())
                    .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(.keyboard)
        .foregroundStyle(.white)
        .background(Color.appDarkGray)
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
                        Image(systemName: "person.fill")
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small.sh())
                    }
                )
                .keyboardType(.emailAddress)
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
            .ignoresSafeArea(.keyboard, edges: .bottom)

            YRoundedTextField(radius: 32) {
                YTextField(
                    text: $viewModel.password,
                    placeholder: "••••••••",
                    placeholderColor: .white.opacity(0.5),
                    isSecure: true,
                    contentType: UITextContentType.password,
                    autoCapitalization: .never,
                    left: {
                        Image("jcon_key")
                            .renderingMode(.template)
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small.sh())
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
        .frame(height: 152)
    }
    
    private var headerImage: some View {
        Image("image_driver")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: UIApplication.shared.screenFrame.width, height: 322.f.sh())
    }
}
