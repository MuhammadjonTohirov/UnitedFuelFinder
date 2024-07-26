//
//  SettingsAppearance.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI

enum SettingsAppearanceRouter: ScreenRoute {
    var id: String {
        switch self {
        case .language:
            return "language"
        case .theme:
            return "theme"
        }
    }
    
    case language
    case theme
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .language:
            ChangeLanguageView()
        case .theme:
            ChangeThemeView()
        }
    }
}

class SettingsAppearViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    @Published var shouldShowAlert: Bool = false
    var route: SettingsAppearanceRouter? {
        didSet {
            pushRoute = route != nil
        }
    }
    
    @Published var pushRoute: Bool = false
}

struct SettingsAppearance: View {
    @StateObject var viewModel: SettingsAppearViewModel = SettingsAppearViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: Image("icon_lang")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "language".localize,
                details: UserSettings.shared.language?.name ?? ""
            ) {
                onClickChangLangugage()
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Icon(systemName: "theatermask.and.paintbrush")
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "theme".localize,
                details: UserSettings.shared.theme?.name ?? ""
            ) {
               onClickChangeTheme()
            }
            
            Spacer()
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 2)
        .navigationTitle("appearance".localize)
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
        .navigationDestination(isPresented: $viewModel.pushRoute) {
            viewModel.route?.screen
                .background(Color.background)
        }
    }
    
    private func onClickChangLangugage() {
        viewModel.route = .language
    }
    
    private func onClickChangeTheme() {
        viewModel.route = .theme
    }
}
