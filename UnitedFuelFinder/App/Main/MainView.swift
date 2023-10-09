//
//  ContentView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import SwiftUI
import UnitedUIKit
import USDK

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel(route: .loading)
    
    var body: some View {
        viewModel.route.screen
            .environmentObject(viewModel)
    }
}

#Preview {
    MainView()
}
