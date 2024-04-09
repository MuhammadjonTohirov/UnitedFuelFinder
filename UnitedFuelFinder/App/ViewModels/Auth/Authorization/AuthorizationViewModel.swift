//
//  AuthorizationViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation

import SwiftUI

enum AuthRoute: ScreenRoute {
    static func == (lhs: AuthRoute, rhs: AuthRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case otp(OtpViewModel)
    case register(_ completion: (Bool) -> Void)
    case pin(PinCodeViewModel)
    case forgotpassword
    
    var id: String {
        return "\(self)"
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .otp(let vm):
            OTPView(viewModel: vm)

        case .register(let completion):
            RegisterProfileView(onRegisterResult: completion)
        case .pin(let vm):
            PinCodeView(viewModel: vm)
        case .forgotpassword:
            ForgotPasswordView()
        }
    }
}

class AuthorizationViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isOfferAccepted: Bool = false
    
    var isValidForm: Bool {
//        isOfferAccepted && 
        username.isValidEmail &&
        !password.isEmpty
    }
    
    @Published var emailError: String?
    
    @Published var route: AuthRoute? = nil {
        didSet {
            present = route != nil
        }
    }
    
    @Published var present: Bool = false
    
    @Published var isLoading: Bool = false
    
    var needRegistration: Bool = false
    
    var otpViewModel: OtpViewModel?
    
    @available(*, deprecated, message: "Not used anymore")
    func showOtp() {
        otpViewModel = .init(title: "confirm_otp".localize, username: username)
        otpViewModel?.confirmOTP = { [weak self] otp in
            guard let self else {
                return (false, nil)
            }
            
            guard UserSettings.shared.lastOTP == otp else {
                return (false, "invalid_otp".localize)
            }
            
            try? await Task.sleep(for: .seconds(0.5))
            
            if self.needRegistration {
                self.showFillProfile()
                self.clearOTPModel()
                return (true, nil)
            }
            
            let error = await self.getAccessToken()
            
            await MainActor.run {
                if let error {
                    self.closeOTP()
                    self.showOnError(error)
                } else {
                    self.needRegistration ? self.showFillProfile() : self.showPinSetup()

                    self.clearOTPModel()
                }
            }
            
            return (error == nil, error?.localizedDescription)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.route = .otp(self.otpViewModel!)
        }
    }
    
    private func closeOTP() {
        DispatchQueue.main.async {
            self.route = nil
            self.clearOTPModel()
        }
    }
    
    private func clearOTPModel(after: CGFloat = 0.6) {
        DispatchQueue.main.asyncAfter(deadline: .now() + after) {
            self.otpViewModel = nil
        }
    }
    
    @available(*, deprecated, message: "Not used anymore")
    private func showFillProfile() {
        DispatchQueue.main.async {
            self.route = .register({ isRegistered in
                if isRegistered {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        Task {
                            let error = await self.getAccessToken()
                            
                            DispatchQueue.main.async {
                                if let error {
                                    self.showOnError(error)
                                } else {
                                    self.showPinSetup()
                                }
                            }
                        }
                    }
                }
            })
        }
    }
    
    private func showMain() {
        Task {
            await appDelegate?.navigate(to: .mainTab)
        }
    }
    
    private func showPinSetup() {
        self.route = .pin(.init(title: "setup_pin".localize, reason: .setup, onResult: { isOK in
            if isOK {
                self.showMain()
            }
        }))
    }
    
    func verifyEmail() {
        guard username.isValidEmail else {
            emailError = "invalid_email".localize
            return
        }
        
        emailError = nil
    }
    
    @available(*, deprecated, message: "Not used anymore")
    func onClickVerifyUsername() {
        showLoading()
        
        Task.init {
            let response = await AuthService.shared.verifyAccount(username)
            
            DispatchQueue.main.async {
                self.hideLoading()
                
                if let result = response.0 {
                    self.needRegistration = !result.exist
                    self.showOtp()
                } else {
                    self.showAlert(message: response.error ?? "Cannot verify account".localize)
                }
            }
        }
    }
    
    func showLoading() {
        mainIfNeeded {
            self.isLoading = true
        }
    }
    
    func hideLoading() {
        mainIfNeeded {
            self.isLoading = false
        }
    }
    
    func onClickAuthenticate() {
        Task {
            let error = await getAccessToken()
            
            mainIfNeeded {
                switch error {
                case .notConfirmedByAdmin:
                    self.showAlert(message: "not_confirmed_by_admin".localize)
                case .userAlreadyExists:
                    self.showAlert(message: "already.exists".localize)
                case .unknown:
                    self.showAlert(message: "unknown.error".localize)
                case .custom(let string):
                    self.showAlert(message: string)
                case nil:
                    self.showPinSetup()
                }
            }
        }
    }
    
    func onClickRegister() {
        route = .register { isOK in
            
        }
    }
    
    private func getAccessToken() async -> AuthNetworkErrorReason? {
        showLoading()
        
        let (isOK, error) = await AuthService.shared.login(username: self.username, password: password)
        
        hideLoading()
        
        return isOK ? nil : error
    }
    
    private func showOnError(_ error: AuthNetworkErrorReason) {
        switch error {
        case .userAlreadyExists:
            self.showError(message: "user_already_exists".localize)
        case .notConfirmedByAdmin:
            self.showError(message: "not_confirmed_by_admin".localize)
        case .unknown:
            self.showError(message: "undefined_error".localize)
        case .custom(let error):
            self.showError(message: error.nilIfEmpty ?? "undefined_error".localize)
//        default:
//            break
        }
    }
}
