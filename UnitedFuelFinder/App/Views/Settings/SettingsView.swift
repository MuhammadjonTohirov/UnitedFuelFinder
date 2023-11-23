//
//  SettingsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/10/23.
//

import Foundation
import SwiftUI

enum SettingsRoute: ScreenRoute {
    var id: String {
        switch self {
        case .editProfile:
            return "editProfile"
        case .contactUs:
            return "contactUs"
        case .changePin:
            return "changePin"
        case .sessions:
            return "sessions"
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

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel = SettingsViewModel()
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
                viewModel.navigate(to: .editProfile)
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
            
            row(image: Image(systemName: "lock.open.rotation")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "Change PIN-code"
            ) {
                viewModel.navigate(to: .changePin(result: { isOK in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        viewModel.route = nil
                    }
                }))
            }
            
            Divider()
            
            row(image: Image(systemName: "doc.badge.clock")
                .resizable()
                .renderingMode(.template)
                .fixedSize()
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "Active sessions"
            ) {
                viewModel.navigate(to: .sessions)
            }
            
            Divider()
            
            row(image: Image("icon_feedback")
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.label)
                .frame(width: 24, height: 24),
                title: "Contact"
            ) {
                viewModel.navigate(to: .contactUs)
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
        .navigationDestination(isPresented: $viewModel.present) {
            viewModel.route?.screen
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
        UserSettings.shared.language = .english
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            mainRouter?.navigate(to: .loading)
        }
    }
}


#Preview {
    NavigationView(content: {
        SettingsView()
    })
}
