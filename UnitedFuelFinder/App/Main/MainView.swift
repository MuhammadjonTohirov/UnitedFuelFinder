//
//  ContentView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel(route: .loading)
    
    var body: some View {
        viewModel.route.screen
            .environmentObject(viewModel)
            .onAppear {
                viewModel.transparentNavigationSetup()
                
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                
                if version != UserSettings.shared.currentVersion {
                    DRecentSearchedAddress.deleteAll()
                }
                
                UserSettings.shared.currentVersion = version
                
                let theme = UserSettings.shared.theme ?? .light
                UserSettings.shared.setInterfaceStyle(style: theme.style)
            }
    }
}

#Preview {
    MainView()
}
