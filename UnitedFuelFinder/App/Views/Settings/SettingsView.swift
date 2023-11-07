//
//  SettingsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/10/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    @State private var showEditProfile: Bool = false
    @State private var showContactUs: Bool = false
    @State private var showLogoutAlert: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            row(image: Image("icon_edit")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24)
                .padding(.bottom, 2)
                .padding(.leading, 2), title: "Edit profile"
            ) {
                showEditProfile = true
            }
             
            Divider()
            
            row(image: Image("icon_lang")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "Language", details: "English"
            ) {
                
            }
            
            Divider()
            
            row(image: Image("icon_feedback")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "Contact"
            ) {
                showContactUs = true
            }
            
            Divider()
            
            row(image: Image("icon_logout")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.init(uiColor: .systemRed))
                .frame(width: 22, height: 22).padding(.leading, -2),
                title: "Logout"
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
        .navigation(isActive: $showContactUs) {
            ContactUsView()
        }
        .navigation(isActive: $showEditProfile) {
            ProfileVIew()
        }
    }
    
    func row<IMG: View>(image: IMG, title: String, details: String = "", onClick: @escaping () -> Void) -> some View {
        Button {
            onClick()
        } label: {
            HStack {
                Circle()
                    .frame(width: 32, height: 32, alignment: .center)
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        image
                    }
                    .padding(.trailing, 8)
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.label)

                Spacer()
                
                Text(details)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.secondary)

                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
            }
        }
    }
    
    private func onClickLogout() {
        showLogoutAlert = true
    }
    
    private func doLogout() {
        UserSettings.shared.clear()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            mainRouter?.navigate(to: .loading)
        }
    }
}


#Preview {
    SettingsView()
}
