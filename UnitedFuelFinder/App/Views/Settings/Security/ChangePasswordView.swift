//
//  ChangePasswordView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/04/24.
//

import Foundation
import SwiftUI

struct ChangePasswordView: View {
    @State private var oldPassword: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
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
        VStack(spacing: 10) {
            form
                .padding(.horizontal, Padding.default)

            Spacer()
            
            SubmitButton {
                changePassword()
            } label: {
                Text("send.request".localize)
            }
            .padding(.horizontal, Padding.default)
            .padding(.bottom, Padding.medium)
        }
        .padding(.top, Padding.small)
        .toast(isPresenting: $showToast) {
            toast ?? .init(type: .regular)
        }
        .navigationTitle("change.password".localize)
        .navigationBarTitleDisplayMode(.inline)
        .background(.appBackground)
    }
    
    // only an email field
    private var form: some View {
        VStack(spacing: 10) {
            YRoundedTextField {
                YTextField(
                    text: $oldPassword,
                    placeholder: "old.password".localize,
                    isSecure: true,
                    contentType: UITextContentType.password,
                    autoCapitalization: .never,
                    left: {
                        Image("jcon_key")
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small)
                    }
                )
                .keyboardType(.default)
            }
            
            YRoundedTextField {
                YTextField(
                    text: $oldPassword,
                    placeholder: "new.password".localize,
                    isSecure: true,
                    contentType: UITextContentType.password,
                    autoCapitalization: .never,
                    left: {
                        Image("jcon_key")
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small)
                    }
                )
                .keyboardType(.default)
            }
            .padding(.top, Padding.medium)
            
            YRoundedTextField {
                YTextField(
                    text: $oldPassword,
                    placeholder: "confirm.password".localize,
                    isSecure: true,
                    contentType: UITextContentType.password,
                    autoCapitalization: .never,
                    left: {
                        Image("jcon_key")
                            .frame(width: 24)
                            .padding(.horizontal, Padding.small)
                    }
                )
                .keyboardType(.default)
            }
        }
    }
    
    private func changePassword() {
        guard confirmPassword == newPassword && !newPassword.isEmpty && !oldPassword.isEmpty else {
            
            showError("invalid.form".localize)
            return
        }
        
        Task {
            if await AuthService.shared.changePassword(
                confirmPassword: confirmPassword,
                oldPassword: oldPassword,
                newPassword: newPassword
            ) {
                showSuccess("change.pass.success".localize)
            } else {
                showError("change.pass.failed".localize)
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
    NavigationStack {
        ChangePasswordView()
    }
}
