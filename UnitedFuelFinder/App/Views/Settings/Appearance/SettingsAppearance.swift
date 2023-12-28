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

class SettingsAppearViewModel: ObservableObject {
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
            
            SettingsViewUtils.row(image: Image(systemName: "theatermask.and.paintbrush")
                .resizable()
                .renderingMode(.template)
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
        .navigationTitle("appearance".localize)
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
        .navigationDestination(isPresented: $viewModel.pushRoute) {
            viewModel.route?.screen
        }
    }
    
    private func onClickChangLangugage() {
        viewModel.route = .language
    }
    
    private func onClickChangeTheme() {
        viewModel.route = .theme
    }
}
