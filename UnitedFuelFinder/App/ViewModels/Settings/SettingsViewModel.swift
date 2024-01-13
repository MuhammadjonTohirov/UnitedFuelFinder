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

class SettingsViewModel: ObservableObject {
    var route: SettingsRoute? {
        didSet {
            self.present = route != nil
        }
    }
    
    @Published var present: Bool = false
    
    func navigate(to route: SettingsRoute) {
        self.route = route
    }
}
