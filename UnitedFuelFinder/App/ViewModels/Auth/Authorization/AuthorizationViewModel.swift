//
//  AuthorizationViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import USDK

class AuthorizationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var isOfferAccepted: Bool = false
    @Published var showOTPConfirm: Bool = false
    
    var otpViewModel: OtpViewModel?
    
    func showOtp() {
        otpViewModel = .init(title: "confirm_otp".localize, username: username)
        otpViewModel?.confirmOTP = { [weak self] otp in
            guard let self else {
                return (false, nil)
            }
            try? await Task.sleep(for: .seconds(0.5))
            self.closeOTP()
            return (false, nil)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.showOTPConfirm = true
        }
    }
    
    private func closeOTP() {
        DispatchQueue.main.async {
            self.showOTPConfirm = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showMain()
            }
        }
    }
    
    private func showMain() {
        mainRouter?.navigate(to: .main)
        UserSettings.shared.canShowMain = true
    }
}
