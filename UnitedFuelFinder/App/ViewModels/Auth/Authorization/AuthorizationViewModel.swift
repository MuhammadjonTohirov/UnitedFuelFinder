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
    case register
    case pin(PinCodeViewModel)
    
    var id: String {
        return "\(self)"
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .otp(let vm):
            OTPView(viewModel: vm)
        case .register:
            RegisterProfileView()
        case .pin(let vm):
            PinCodeView(viewModel: vm)
        }
    }
}

class AuthorizationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isOfferAccepted: Bool = false
    @Published var route: AuthRoute? = nil {
        didSet {
            present = route != nil
        }
    }
    
    @Published var present: Bool = false
    
    @Published var isLoading: Bool = false
    
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
                self.showFillProfile()
            }
        }
    }
    
    private func showFillProfile() {
        DispatchQueue.main.async {
            self.route = .register
        }
    }
    
    private func showMain() {
        mainRouter?.navigate(to: .main)
        UserSettings.shared.canShowMain = true
    }
    
    func onClickLogin() {
        showLoading()
        Task.init {
            guard let _ = await AuthService.shared.verifyAccount(username) else {
                self.hideLoading()
                return
            }
            
            DispatchQueue.main.async {
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
}
