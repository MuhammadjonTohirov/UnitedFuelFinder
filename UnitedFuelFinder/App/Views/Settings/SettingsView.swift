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
        innerBody
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("settings".localize)
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Text("")
                }
            })
            .background(Color.background)
    }
    
    var innerBody: some View {
        VStack(spacing: 12) {
            SettingsViewUtils.row(image: userAvatar, title: UserSettings.shared.userInfo?.fullName ?? "profile".localize.capitalized
            ) {
                viewModel.navigate(to: .profile)
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
            
            HStack(spacing: 2) {
                Spacer()
                
                Text("app_version".localize + ":")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.init(uiColor: .systemRed))
                    .onTapGesture {
                        #if DEBUG
                        viewModel.clearCache()
                        #endif
                    }
                //Text(UserSettings.shared.currentAPIVersion?.nilIfEmpty ?? Bundle.main.appVersion)
                Text(Bundle.main.appVersion)
                    .foregroundStyle(Color.label)
                
                Spacer()
            }
            .font(.caption)
            .padding()
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
                .background(Color.background)
        }
    }
    
    private var userAvatar: some View {
        KF(
            imageUrl: UserSettings.shared.userAvatarURL,
            cacheKey: (UserSettings.shared.photoUpdateDate ?? Date()).toString(),
            storageExpiration: .expired,
            memoryExpiration: .expired,
            placeholder: Image(uiImage: UIImage(named: "icon_man_placeholder")!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24.f.sw(), height: 24.f.sw(), alignment: .center)
                .clipShape(Circle())
                .anyView
        )
        .frame(width: 24.f.sw(), height: 24.f.sw())
        .background {
            Circle()
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
        }
    }
    
    private func onClickLogout() {
        showLogoutAlert = true
    }
    
    private func doLogout() {
        UserSettings.shared.clear()
        UserSettings.shared.language = .english
        appDelegate?.timer?.invalidate()
        appDelegate?.timer = nil
        Task {
            await appDelegate?.navigate(to: .loading)
        }
    }
}


#Preview {
    NavigationView(content: {
        SettingsView()
            .environmentObject(MainViewModel())
    })
}
