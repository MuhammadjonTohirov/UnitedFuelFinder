//
//  MainTabView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 31/01/24.
//

import Foundation
import SwiftUI

enum MainTabs: Int {
    case dashboard
    case map
    case settings
}

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel = .init()
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var didAppear = false
    @State private var mapBodyState: HomeBodyState = .map
    @State private var imagePlaceholder: Image?
    
    var body: some View {
        ZStack {
            NavigationStack {
                tabView
                    .alert(isPresented: $viewModel.showWarningAlert) {
                        Alert(
                            title: Text("disclamer.title".localize),
                            message: Text("disclamer.desc".localize),
                            dismissButton: .default(
                                Text("ok".localize)
                            )
                        )
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .onAppear {
                        viewModel.onAppear()
                    }
                    .onAppear {
                        if didAppear {
                            return
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            viewModel.alertWarning()
                            self.didAppear = true
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    private var leadingTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Image("icon_bell_active")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.init(uiColor: .label))
                .onTapGesture {
                    viewModel.dashboardViewModel.navigate(to: .notifications)
                }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var centerTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Text("Dashboard")
                .font(.system(size: 16, weight: .bold))
        case .map:
            MapTabToggleView(selectedIndex: $mapBodyState)
        case .settings:
            Text("Settings")
                .font(.system(size: 16, weight: .bold))
        }
    }
    
    @ViewBuilder
    private var trailingTopBar: some View {
        switch viewModel.selectedTag {
        case .map:
            Image("icon_filter_2")
                .onTapGesture {
                    if let filter = self.viewModel.mapViewModel.filter {
                        self.viewModel.mapViewModel.route = .filter(filter, { newFilter in
                            self.viewModel.mapViewModel.set(filter: newFilter)
                            self.viewModel.mapViewModel.route = nil
                        })
                    }
                }
        case .dashboard:
            KF(
                imageUrl: UserSettings.shared.userAvatarURL,
                cacheKey: (UserSettings.shared.photoUpdateDate ?? Date()).toString(),
                storageExpiration: .expired,
                memoryExpiration: .expired,
                placeholder: imagePlaceholder?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32.f.sw(), height: 32.f.sw(), alignment: .center)
                    .clipShape(Circle())
                    .anyView ?? EmptyView().anyView
            )
            .frame(width: 32.f.sw(), height: 32.f.sw())
            .background {
                Circle()
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
            }
            .onTapGesture {
                viewModel.dashboardViewModel.navigate(to: .profile)
            }
            .onAppear {
                if let img = UIImage(named: "icon_man_placeholder") {
                    self.imagePlaceholder = Image(uiImage: img)
                }
            }
        default:
            Text("")
        }
    }
    
    private var tabView: some View {
        TabView(selection: $viewModel.selectedTag) {
            DashboardView(viewModel: viewModel.dashboardViewModel as! DashboardViewModel)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_pie")
                        .renderingMode(.template)
                    Text("dashboard".localize)
                }
                .tag(MainTabs.dashboard)

            MapTabView(viewModel: viewModel.mapViewModel as! MapTabViewModel)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_map_2")
                        .renderingMode(.template)
                    Text("map".localize)
                }
                .tag(MainTabs.map)

            SettingsView()
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_settings")
                        .renderingMode(.template)
                    Text("settings".localize)
                }
                .tag(MainTabs.settings)
        }
        .onChange(of: mapBodyState, perform: { value in
            viewModel.mapViewModel.bodyState = value
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                leadingTopBar
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                trailingTopBar
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                centerTopBar
            }
        })
        .onChange(of: viewModel.selectedTag, perform: { value in
            switch value {
            case .dashboard:
                debugPrint("On select dashboard")
            case .map:
                debugPrint("On select map")
                viewModel.onSelectMapTab()
            case .settings:
                debugPrint("On select settings")
            }
        })
        .accentColor(.accent)
    }
}

#Preview {
    UserSettings.shared.accessToken = UserSettings.testAccessToken
    UserSettings.shared.refreshToken = UserSettings.testRefreshToken
    UserSettings.shared.userEmail = UserSettings.testEmail
    UserSettings.shared.tokenExpireDate = Date().after(days: 2)
    UserSettings.shared.appPin = "0000"
    
    return MainView()
}
