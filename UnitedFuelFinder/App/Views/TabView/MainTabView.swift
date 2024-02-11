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
    
    private var leadingTopBar: some View {
        Text("")
    }
    
    @ViewBuilder
    private var centerTopBar: some View {
        switch selectedTag {
        case .dashboard:
            Text("Dashboard")
        case .map:
            MapTabToggleView(selectedIndex: $viewModel.mapViewModel.bodyState)
        case .settings:
            Text("Settings")
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
        default:
            Text("")
//            if mainViewModel.isLoading {
//                LoadingView()
//            } 
        }
    }
    
    private var tabView: some View {
        TabView(selection: $selectedTag) {
            Text("Page1")
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
    MainView()
}
