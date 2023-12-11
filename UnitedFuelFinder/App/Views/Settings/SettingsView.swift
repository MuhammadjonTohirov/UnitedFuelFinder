//
//  SettingsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/10/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var showLogoutAlert: Bool = false
    @EnvironmentObject var mainModel: MainViewModel
    var body: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: Image("icon_edit")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24)
                .padding(.bottom, 2)
                .padding(.leading, 2), title: "edit_profile".localize
            ) {
                viewModel.navigate(to: .editProfile)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_appearance")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "appearance".localize
            ) {
                viewModel.navigate(to: .appearance)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_map_settings")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "map_settings".localize
            ) {
                viewModel.navigate(to: .mapSettings)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image(systemName: "lock")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "security".localize
            ) {
                viewModel.navigate(to: .security)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_feedback")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "contact_us".localize
            ) {
                viewModel.navigate(to: .contactUs)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_logout")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.init(uiColor: .systemRed))
                .frame(width: 22, height: 22).padding(.leading, -2),
                title: "logout".localize
            ) {
                onClickLogout()
            }
            
            Spacer()
        }
        .alert(isPresented: $showLogoutAlert) {
            Alert(
                title: Text(
                    "logout".localize.capitalized
                ),
                message: Text(
                    "logout_message".localize
                ),
                primaryButton: .cancel(),
                secondaryButton: .destructive(Text(
                    "logout".localize.capitalized
                ), action: {
                    doLogout()
                })
            )}
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("settings".localize.capitalized)
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
        .navigationDestination(isPresented: $viewModel.present) {
            viewModel.route?.screen
                .environmentObject(self.mainModel)
                .environmentObject(self.viewModel)
        }
    }
    
    private func onClickLogout() {
        showLogoutAlert = true
    }
    
    private func doLogout() {
        UserSettings.shared.clear()
        UserSettings.shared.language = .english
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            mainRouter?.navigate(to: .loading)
        }
    }
}


#Preview {
    NavigationView(content: {
        SettingsView()
            .environmentObject(MainViewModel())
    })
}
