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
   
    private var userFullName: String {
        UserSettings.shared.userInfo?.fullName ?? "profile".localize.capitalized
    }
    
    private var userType: UserType {
        UserSettings.shared.userType ?? .driver
    }
    
    var body: some View {
        innerBody
            .background(content: {
                VStack {
                    Spacer()
                    Image("image_placeholder")
                        .padding(.bottom, Padding.large * 2)
                }
            })
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
            profileRow.onTapGesture {
                self.viewModel.route = .profile
            }
            
            Divider()
            
            SettingsViewUtils.row(
                image: Image("icon_appearance")
                    .resizable()
                    .renderingMode(.template)
                    .fixedSize()
                    .foregroundStyle(Color.label)
                    .frame(width: 24, height: 24),
                title: "appearance".localize,
                descr: "lang.theme".localize
            ) {
                viewModel.navigate(to: .appearance)
            }
            
            Divider()
            
            SettingsViewUtils.row(
                image: Image(systemName: "lock")
                    .resizable()
                    .renderingMode(.template)
                    .fixedSize()
                    .foregroundStyle(Color.label)
                    .frame(width: 24, height: 24),
                title: "security".localize,
                descr: "change.pin.devcsess.pass".localize
            ) {
                viewModel.navigate(to: .security)
            }
            
            Divider()
            
            SettingsViewUtils.row(
                image: Image("icon_feedback")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .frame(width: 24, height: 24),
                title: "contact_us".localize,
                descr: "email.help.service".localize
            ) {
                viewModel.navigate(to: .contactUs)
            }
            
            Divider()
            
            if userType == .company {
                SettingsViewUtils.row(
                    image: Image("icon_driver")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.label)
                        .frame(width: 24, height: 24),
                    title: "manage.drivers".localize,
                    descr: "driver.set".localize
                ) {
                    viewModel.navigate(to: .manageDriver)
                }
                
                Divider()
            }
            
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
            storageExpiration: .seconds(10),
            memoryExpiration: .seconds(10),
            placeholder: Circle()
                .foregroundStyle(.gray.opacity(0.3))
                .frame(
                    width: 72.f.sw(),
                    height: 72.f.sw(),
                    alignment: .center
                )
                .opacity(0.1)
                .overlay {
                    ProgressView()
                }
                .anyView
        )
        .frame(
            width: 72.f.sw(),
            height: 72.f.sw()
        )
        .background {
            Circle()
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
        }
    }
    
    private var profileRow: some View {
        HStack(spacing: 12) {
            userAvatar

            VStack(alignment: .leading, spacing: 7.f.sh()) {
                Text(userFullName)
                    .font(.bold(size: 20))
                Text("edit.delete".localize)
                    .font(.regular(size: 12))
            }
            Spacer()
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
    UserSettings.shared.setupForTest()
    return NavigationStack {
        SettingsView()
            .environmentObject(MainViewModel())
    }
}
