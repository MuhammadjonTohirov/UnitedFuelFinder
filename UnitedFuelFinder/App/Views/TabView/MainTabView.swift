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
    @ObservedObject var viewModel: TabViewModel = .init()
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var selectedTag: MainTabs = .dashboard
    
    var body: some View {
        NavigationStack {
            tabView
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    private var leadingTopBar: some View {
        switch selectedTag {
        case .dashboard:
            Image(systemName: "bell")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.init(uiColor: .label))
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var centerTopBar: some View {
        switch selectedTag {
        case .dashboard:
            Text("Dashboard")
                .font(.system(size: 16, weight: .bold))
        case .map:
            MapTabToggleView(selectedIndex: $viewModel.mapViewModel.bodyState)
        case .settings:
            Text("Settings")
                .font(.system(size: 16, weight: .bold))
        }
    }
    
    @ViewBuilder
    private var trailingTopBar: some View {
        switch selectedTag {
        case .map:
            Image("icon_filter_2")
                .onTapGesture {
                    self.viewModel.mapViewModel.route = .filter
                }
        case .dashboard:
            Image("icon_man_placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .cornerRadius(20)
        default:
            Text("")
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedTag) {
            DashboardView()
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_pie")
                        .renderingMode(.template)
                    Text("home".localize)
                }
                .tag(MainTabs.dashboard)
            
            MapTabView()
                .environmentObject(mainViewModel)
                .environmentObject(viewModel.mapViewModel)
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
        .accentColor(.accent)
    }
}

#Preview {
    UserSettings.shared.accessToken = UserSettings.testAccessToken
    UserSettings.shared.refreshToken = UserSettings.testRefreshToken
    UserSettings.shared.userEmail = UserSettings.testEmail
    UserSettings.shared.appPin = "0000"
    
    return MainView()
}
