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
    @State private var readyToDeleteProfile: Bool = false
    @State private var showOTP: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: Image("icon_edit")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "edit_profile".localize
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
                onClickDelete()
            }
            
            Spacer()
        }
        .alert(isPresented: $settingsModel.alertShow, content: {
            Alert(title: Text("delete_profile".localize),
                  message: Text("delete_profile_message".localize),
                  primaryButton: .cancel(),
                  secondaryButton: .destructive(Text("delete".localize), action: {
                deleteProfile()
            }))
        })
        .navigationDestination(isPresented: $showProfileEdit, destination: {
            ProfileVIew()
        })
        .navigationDestination(isPresented: $settingsModel.otpShow, destination: {
            if let vm = settingsModel.otpModel {
                OTPView(viewModel: vm)
            }
        })
        .navigationTitle(UserSettings.shared.userInfo?.fullName ?? "")
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
    }
    
    private func onClickDelete() {
        settingsModel.alertShow = true
    }
    
    private func deleteProfile() {
        Task {
            if await AuthService.shared.deleteProfileRequest() {
                onSuccessDeleteRequest()
            }
        }
    }
    
    private func onSuccessDeleteRequest() {
        settingsModel.showOTPForDeleteConfirm()
    }
}
