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
    @State private var screenSize: CGRect = .zero
    
    var body: some View {
        ZStack {
            innerBody
                .keyboardDismissable()
            
            VStack {
                Spacer()
                nextButton
            }
            .padding(.bottom, Padding.medium)
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .overlay {
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    screenSize = geometry.frame(in: .global)
                })
            })
        }
    }
    
    var innerBody: some View {
        VStack(alignment: .leading) {
            headlines
            fieldView
            Text("")
                .frame(height: 100)
                .ignoresSafeArea()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var headlines: some View {
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
    }
    
    private var fieldView: some View {
        YRoundedTextField(textField: {
            YTextField(text: $viewModel.otp, placeholder: "confirmation_code".localize, contentType: .oneTimeCode, right: {
                HStack {
                    Rectangle()
                        .frame(width: 0.5, height: 44)
                        .foregroundColor(Color("gray"))
                        .padding(.trailing, 4)
                    Text(viewModel.shouldResend ? "retry".localize : viewModel.counter)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(viewModel.shouldResend ? .accent : .secondary)
                        .onTapGesture {
                            if viewModel.shouldResend {
                                viewModel.requestForOTP()
                            }
                        }
                }
                .padding(.trailing, 12)
            })
            .keyboardType(.numberPad)
            .set(format: "XXXXXX")
        })
        .onChange(of: viewModel.otp, perform: { _ in
            self.viewModel.onTypingOtp()
        })
        .modifier(YTextFieldBottomInfo(text: viewModel.otpErrorMessage, color: Color.red))
        .padding(Padding.default)
    }
    
    private var nextButton: some View {
        SubmitButton(action: {
            viewModel.onClickConfirm()
        }, label: {
            Text("next".localize)
        })
        .padding(.horizontal, Padding.default)
    }
}

#Preview {
    OTPView(viewModel: OtpViewModel(username: "master@mail.uz"))
}
