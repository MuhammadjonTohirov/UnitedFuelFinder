//
//  SettingsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI


enum SettingsRoute: ScreenRoute {
    var id: String {
        switch self {
        case .profile:
            return "profile"
        case .editProfile:
            return "editProfile"
        case .contactUs:
            return "contactUs"
        case .changePin:
            return "changePin"
        case .sessions:
            return "sessions"
        case .language:
            return "language"
        case .appearance:
            return "appearance"
        case .security:
            return "security"
        case .mapSettings:
            return "mapSettings"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SettingsRoute, rhs: SettingsRoute) -> Bool {
        lhs.id == rhs.id
    }
    
    case editProfile
    case contactUs
    case sessions
    case changePin(result: (Bool) -> Void)
    case language
    case appearance
    case security
    case mapSettings
    case profile
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .editProfile:
            ProfileVIew()
        case .contactUs:
            ContactUsView()
        case .changePin(let res):
            PinCodeView(viewModel: .init(title: "setup_pin".localize, reason: .setup, onResult: res))
        case .sessions:
            SessionsView()
        case .language:
            ChangeLanguageView()
        case .profile:
            SettingsProfile()
                .navigationTitle("profile".localize)
        case .appearance:
            SettingsAppearance()
                .navigationTitle("appearance".localize)
        case .security:
            SettingsSecurity()
        case .mapSettings:
            SettingsMap()
        }
    }
}

protocol SettingsProfileModelProtocol: ObservableObject {
    var otpModel: OtpViewModel? {get set}
    var alertShow: Bool {get set}
    var otpShow: Bool {get set}

    func showOTPForDeleteConfirm()
    func confirmDeleteProfile(_ otp: String) async -> (Bool, String?)
}

class SettingsViewModel: NSObject, ObservableObject, SettingsProfileModelProtocol {
    var route: SettingsRoute? {
        didSet {
            self.present = route != nil
        }
    }
    
    var otpModel: OtpViewModel?
    @Published var alertShow: Bool = false
    @Published var otpShow: Bool = false
    
    @Published var present: Bool = false
    
    func navigate(to route: SettingsRoute) {
        self.route = route
    }
    
    func showOTPForDeleteConfirm() {
        otpModel = .init(username: UserSettings.shared.userEmail ?? "")
        otpModel?.delegate = self
        otpModel?.confirmOTP = { [weak self] (otp) async -> (Bool, String?) in
            let res = await self?.confirmDeleteProfile(otp) ?? (false, nil)
            
            if res.0 {
                self?.showLoadingScreen()
            }
            
            return res
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.otpShow = true
        }
    }
    
    func confirmDeleteProfile(_ otp: String) async -> (Bool, String?) {
        if let session = UserSettings.shared.session {
            return (await AuthService.shared.confirmDeleteProfile(session: session, code: otp), nil)
        }
        
        return (false, "invalid_otp".localize)
    }
    
    private func showLoadingScreen() {
        DispatchQueue.main.async {
            self.otpShow = false
            self.otpModel = nil
            Task {
                UserSettings.shared.clear()
                await appDelegate?.navigate(to: .loading)
            }
        }
    }
 }

extension SettingsViewModel: OtpModelDelegate {
    func otp(model: OtpViewModel, isSuccess: Bool) {
        
    }
}
