//
//  ForgotPasswordView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/04/24.
//

import Foundation
import SwiftUI

struct ForgotPasswordView: View {
    @State private var username: String = ""
    @State private var error: String = ""
    @State private var showToast = false
    
    @State private var toast: AlertToast? {
        didSet {
            showToast = true
        }
    }
    
    @Environment(\.dismiss)
    var dismiss
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("forgot.password".localize)
                    .font(.lato(size: 24, weight: .semibold))
                    .padding(.horizontal, Padding.medium)
                
                Text("enter.email.to.reset.pass".localize)
                    .font(.lato(size: 14, weight: .medium))
                    .padding(.horizontal, Padding.medium)
                
                VStack(spacing: 10) {
                    form
                }
                .padding(.horizontal, Padding.medium)
                .padding(.top, Padding.small)
            }
            .offset(y: -2*Padding.large.sh())
            
            VStack {
                Spacer()
                
                SubmitButton {
                    resetPassword()
                } label: {
                    Text("send.request".localize)
                }
                .padding(.horizontal, Padding.default)
                .padding(.bottom, Padding.medium)
            }
        }
        .toast(isPresenting: $showToast) {
            toast ?? .init(type: .regular)
        }
        .background(.appBackground)
    }
    
    // only an email field
    private var form: some View {
        VStack(spacing: 10) {
            YRoundedTextField {
                YTextField(
                    text: $username,
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
            .set(error: error)
        }
    }
    
    private func resetPassword() {
        guard username.isValidEmail else {
            error = "invalid_email".localize
            return
        }
        UIApplication.shared.dismissKeyboard()
        Task {
            let isOK = await AuthService.shared.forgotPassword(email: username)
            
            isOK ? showSuccess("reset.pass.success".localize) : showError("reset.pass.failed".localize)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {            if isOK {
                    dismiss.callAsFunction()
                }
            }
        }
    }
    
    func showError(_ msg: String) {
        self.toast = .init(
            displayMode: .alert,
            type: .error(.init(uiColor: .systemRed)),
            title: msg
        )
    }
    
    func showSuccess(_ msg: String) {
        self.toast = .init(
            displayMode: .alert,
            type: .complete(.init(uiColor: .systemGreen)),
            title: msg
        )
    }
}

#Preview {
    ForgotPasswordView()
}
