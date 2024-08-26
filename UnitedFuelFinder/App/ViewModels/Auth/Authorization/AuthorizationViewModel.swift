//
//  AuthorizationViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import AuthenticationServices
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
    
    @Published var userType: UserType = .driver
    
    var isDriver: Bool {
        userType == .driver
    }
    
    var pageTitle: String {
        isDriver ? "driver".localize : "company".localize
    }
    
    var isValidForm: Bool {
        username.isValidEmail &&
        !password.isEmpty
    }
    
    @Published var emailError: String?
    
    @Published var route: AuthRoute? = nil {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                self.present = self.route != nil
            }
        }
    }
    
    @Published var present: Bool = false
    
    @Published var isLoading: Bool = false
    
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
            
            let error = await self.getAccessToken()
            
            await MainActor.run {
                if let error {
                    self.closeOTP()
                    self.showOnError(error)
                } else {
                    self.showPinSetup()
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
        Task(priority: .high) {
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
                if let obj = error{
                    self.showAlert(message: obj.localizedDescription)
                } else{
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
        
        if isOK {
            await AuthService.shared.syncUserInfo()
            await MainService.shared.syncCustomers()
            await MainService.shared.syncAllStations()
        }
        
        hideLoading()
        
        return isOK ? nil : error
    }
    
    private func showOnError(_ error: AuthNetworkErrorReason) {
        self.showError(message: error.localizedDescription)
    }
    
    func loginWithApple() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.email]
        
        let authorizationController =  ASAuthorizationController(
            authorizationRequests: [request]
        )
        authorizationController.delegate = self
        authorizationController.performRequests(options: [
            .preferImmediatelyAvailableCredentials
        ])
    }
}

extension AuthorizationViewModel: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: any Error) {
        self.showError(message: error.localizedDescription)
    }
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard
            let credential = authorization.credential as? ASAuthorizationAppleIDCredential//,
        else { return }
        
        guard let email = credential.email?.nilIfEmpty else {
            self.showError(message: "unable.to.detect.email".localize)
            return
        }
        
        self.showLoading()
        
        Task {
            let result = await AuthService.shared.verifyAccount(email)
            
            await MainActor.run {
                self.hideLoading()
                
                if result.0 {
                    self.showPinSetup()
                    self.clearOTPModel()
                } else if let error = result.error {
                    debugPrint(error.localizedDescription)
                }
            }
        }
    }
}
