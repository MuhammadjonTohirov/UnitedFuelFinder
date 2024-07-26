//
//  OTPView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import SwiftUI


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
        .background(.appBackground)
        .overlay {
            GeometryReader(content: { geometry in
                Color.clear.onAppear(perform: {
                    screenSize = geometry.frame(in: .global)
                })
            })
        }
        .overlay {
            Rectangle()
                .ignoresSafeArea()
                .foregroundColor(.black.opacity(0.15))
                .overlay {
                    ProgressView()
                }
                .opacity(self.viewModel.loading ? 1 : 0)
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
                .font(.lato(size: 24, weight: .semibold))
                .multilineTextAlignment(.center)
            
            Text("otp_sent_to_email".localize)
                .font(.lato(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                
            
            Text(viewModel.username.nilIfEmpty ?? "somebody@gmail.com")
                .foregroundStyle(Color.accent)
        }
        .padding(.horizontal, Padding.default)
        .font(.lato(size: 14, weight: .regular))
    }
    
    private var fieldView: some View {
        YRoundedTextField(textField: {
            YTextField(text: $viewModel.otp, placeholder: "confirmation_code".localize, contentType: .oneTimeCode, right: {
                HStack {
                    Rectangle()
                        .frame(width: 0.5, height: 44)
                        .foregroundColor(Color.init(uiColor: .secondaryLabel))
                        .padding(.trailing, 4)
                    Text(viewModel.shouldResend ? "retry".localize : viewModel.counter)
                        .font(.lato(size: 14, weight: .medium))
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
        .set(error: viewModel.otpErrorMessage)
        .onChange(of: viewModel.otp, perform: { _ in
            self.viewModel.onTypingOtp()
        })
        .padding(Padding.default)
        .alert(isPresented: $viewModel.showAlert, error: viewModel.otpErrorMessage) {
            Button("ok".localize.uppercased(), role: .cancel) {
                viewModel.showAlert = false
            }
        }
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

extension String: LocalizedError {
    public var errorDescription: String? {
        return self
    }
}
