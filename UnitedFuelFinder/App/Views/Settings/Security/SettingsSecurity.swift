//
//  SettingsSecurity.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI

struct SettingsSecurity: View {
    @EnvironmentObject var viewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: Image(systemName: "lock.open.rotation")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "change_pin".localize
            ) {
                viewModel.navigate(to: .changePin(result: { isOK in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        viewModel.route = nil
                    }
                }))
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_devices")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "device_sess".localize
            ) {
                viewModel.navigate(to: .sessions)
            }
            
            Divider()
            
            SettingsViewUtils.row(image: Image("icon_reset_password")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "change.password".localize
            ) {
                viewModel.navigate(to: .changePassword)
            }
            Spacer()
        }
        .navigationTitle("security".localize)
        .padding(.horizontal, 20)
        .padding(.top, Padding.medium)
    }
}
