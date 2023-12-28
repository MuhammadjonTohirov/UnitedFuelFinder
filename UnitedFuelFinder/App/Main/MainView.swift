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
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                
                let back = UIBarButtonItemAppearance(style: .done)
                back.normal.backgroundImage = UIImage()
                
                back.normal.titlePositionAdjustment = .init(horizontal: -1000, vertical: 0)
                
                appearance.backButtonAppearance = back
                appearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
                
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
