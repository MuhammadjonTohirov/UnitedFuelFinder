//
//  OTPView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import SwiftUI
import UnitedUIKit

struct OTPView: View {
    @ObservedObject var viewModel: OtpViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        innerBody
            .modifier(TopLeftDismissModifier())
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            VStack(alignment: .leading, spacing: 7) {
                Text(viewModel.title)
                    .font(.system(size: 24, weight: .semibold))
                    .multilineTextAlignment(.center)
                
                Text("otp_sent_to_email".localize)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
                    
                
                Text(viewModel.username.nilIfEmpty ?? "somebody@gmail.com")
                    .foregroundStyle(Color.accent)
            }
            .padding(.horizontal, Padding.default)
            .font(.system(size: 14, weight: .regular))
            
            YTextField(text: $viewModel.otp, placeholder: "confirmation_code".localize, contentType: .oneTimeCode, right: {
                HStack {
                    Rectangle()
                        .frame(width: 0.5, height: 44)
                        .foregroundColor(Color("gray"))
                        .padding(.trailing, 4)
                    Text("60")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
                .padding(.trailing, 12)
            })
            .keyboardType(.numberPad)
            .onChange(of: viewModel.otp, perform: { _ in
                self.viewModel.onTypingOtp()
            })
            .modifier(YTextFieldBackgroundCleanStyle(padding: Padding.default))
            .modifier(YTextFieldBottomInfo(text: viewModel.otpErrorMessage, color: Color.red))
            .padding(Padding.default)
            
            Spacer()
            
            SubmitButton(action: {
                viewModel.onClickConfirm()
            }, label: {
                Text("next".localize)
            })
            .padding(.horizontal, Padding.default)
            .padding(.bottom, 8)
            
            Button {
                viewModel.requestForOTP()
            } label: {
                Text("send_again".localize)
                    .foregroundColor(viewModel.shouldResend ? Color("accent_light_2") : Color("dark_gray"))
            }
            .disabled(!viewModel.shouldResend)
            
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

