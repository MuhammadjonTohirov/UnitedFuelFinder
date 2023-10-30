//
//  PinCodeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import SwiftUI


import LocalAuthentication

struct PinCodeView: View {
    @StateObject var viewModel = PinCodeViewModel(
        title: "setup_pin".localize, reason: .confirm(pin: "12"))
    
    let keyboardHeight: CGFloat = 288.f.sh(limit: 0.2)
    
    @ViewBuilder var body: some View {
        innerBody
            .set(hasDismiss: viewModel.reason.id == PinViewReason.confirm(pin: "").id)
    }
    
    var innerBody: some View {
        VStack(spacing: 0) {
            Spacer()
            Text(viewModel.title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.label)

            Spacer()

            HStack(spacing: Padding.medium) {
                ForEach(0..<viewModel.maxCharacters, id: \.self) { id in
                    pinItem(id)
                }
            }
            .foregroundColor(.init(uiColor: .secondaryLabel))
            .padding(Padding.large * 2)
            
            KeyboardView(text: $viewModel.pin, viewModel: viewModel.keyboardModel) {
                if viewModel.reason == .login {
                    UserSettings.shared.appPin = nil
                    mainRouter?.navigate(to: .auth)
                }
            }
            .onChange(of: viewModel.pin) { newValue in
                if newValue.count == viewModel.maxCharacters {
                    viewModel.onEditingPin()
                }
            }
            
            if viewModel.reason != .login {
                SubmitButton(action: {
                    viewModel.onClickNext()
                }, label: {
                    Text("next".localize)
                })
                .padding(Padding.default)
            }
        }
        .multilineTextAlignment(.center)
        .fullScreenCover(item: $viewModel.route) { dest in
            dest.screen
        }
        .onAppear {
            if viewModel.reason == .login {
                authenticate()
            }
        }
    }
    
    private func pinItem(_ id: Int) -> some View {
        Circle()
            .frame(width: 20.f.sh(limit: 0.2))
            .foregroundColor(id >= viewModel.pin.count ? .secondary.opacity(0.2) : .accent)
    }
    
    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "login_with_biometric_id".localize

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    viewModel.onSuccessLogin()
                } else {
                    // there was a problem
                }
            }
        } else {
            // no biometrics
        }
    }
}

struct PinCodeView_Preview: PreviewProvider {
    static var previews: some View {
        PinCodeView(viewModel: PinCodeViewModel(title: "setup_pin".localize, reason: .setup))
    }
}

extension View {
    @ViewBuilder func set(hasDismiss: Bool) -> some View {
        if hasDismiss {
            self.modifier(TopLeftDismissModifier())
        } else {
            self
        }
    }
}
