//
//  SettingsProfile.swift
//  UnitedFuelFinder
//
//  Created by applebro on 13/01/24.
//

import Foundation
import SwiftUI

struct SettingsProfile: View {
    @EnvironmentObject var settingsModel: SettingsViewModel
    @State private var showProfileEdit: Bool = false
    var body: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: Image("icon_edit")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "edit_profile".localize,
                details: UserSettings.shared.language?.name ?? ""
            ) {
                showProfileEdit = true
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_delete_profile")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.init(uiColor: .systemRed))
                .frame(width: 22, height: 22).padding(.leading, -2),
                title: "delete_profile".localize
            ) {
                
            }
            
            Spacer()
        }
        .navigationDestination(isPresented: $showProfileEdit, destination: {
            ProfileVIew()
        })
        .navigationTitle(UserSettings.shared.userInfo?.fullName ?? "")
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
    }
}
