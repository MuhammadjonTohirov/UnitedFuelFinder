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
        }
    }
}

class AuthorizationViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var username: String = ""
    @Published var isOfferAccepted: Bool = false
    @Published var route: AuthRoute? = nil {
        didSet {
            present = route != nil
        }
    }
    
    @Published var present: Bool = false
    
    @Published var isLoading: Bool = false
    
    var needRegistration: Bool = false
    
    var otpViewModel: OtpViewModel?
    
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
            self.closeOTP()
            
            return (true, nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.route = .otp(self.otpViewModel!)
        }
    }
    
    private func closeOTP() {
        DispatchQueue.main.async {
            self.route = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.otpViewModel = nil
                self.needRegistration ?
                self.showFillProfile() :
                self.getAccessToken()
            }
        }
    }
    
    private func showFillProfile() {
        DispatchQueue.main.async {
            self.route = .register({ isRegistered in
                if isRegistered {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        self.getAccessToken()
                    }
                }
            })
        }
    }
    
    private func showMain() {
        mainRouter?.navigate(to: .main)
    }
    
    func onClickVerifyUsername() {
        showLoading()
        Task.init {
            guard let result = await AuthService.shared.verifyAccount(username) else {
                self.hideLoading()
                return
            }
            
            DispatchQueue.main.async {
                self.needRegistration = !result.exist
                self.hideLoading()
                self.showOtp()
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
    
    private func getAccessToken() {
        Task {
            guard let session = UserSettings.shared.session, let code = UserSettings.shared.lastOTP else {
                return
            }
            
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let (isOK, error) = await AuthService.shared.login(session: session, code: code, username: self.username)
            
            DispatchQueue.main.async {
                self.isLoading = false
                
                if isOK {
                    self.showMain()
                } else {
                    switch error {
                    case .userAlreadyExists:
                        self.showError(message: "user_already_exists".localize)
                    case .notConfirmedByAdmin:
                        self.showError(message: "not_confirmed_by_admin".localize)
                    case .unknown:
                        self.showError(message: "undefined_error".localize)
                    case .custom(let error):
                        self.showError(message: error.nilIfEmpty ?? "undefined_error".localize)
                    default:
                        break
                    }
                }
            }
        }
    }
}
