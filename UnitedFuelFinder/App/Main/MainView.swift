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
                UserSettings.shared.setInterfaceStyle(style: .light)
                appDelegate?.defaultNavigationSetup()
                
                let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
                
                if version != UserSettings.shared.currentVersion {
                    DRecentSearchedAddress.deleteAll()
                }
                
                UserSettings.shared.currentVersion = version
            }
    }
}

#Preview {
    MainView()
}
