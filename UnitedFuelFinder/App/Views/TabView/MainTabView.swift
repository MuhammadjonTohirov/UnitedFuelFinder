//
//  MainTabView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 31/01/24.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            tabView
//            if mainViewModel.isLoading {
//                LoadingView()
//            }
        }
    }
    
    private var tabView: some View {
        TabView {
            Text("Page1")
                .tabItem {
                    Image("icon_pie")
                        .renderingMode(.template)
                    Text("home".localize)
                }
            
            TabMapView()
                .tabItem {
                    Image("icon_map_2")
                        .renderingMode(.template)
                    Text("map".localize)
                }
            
            SettingsView()
                .tabItem {
                    Image("icon_settings")
                        .renderingMode(.template)
                    Text("settings".localize)
                }
        }
        .accentColor(.accent)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MainViewModel())
}
