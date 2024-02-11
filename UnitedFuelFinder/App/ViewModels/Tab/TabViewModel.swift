//
//  TabViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation

class TabViewModel: ObservableObject {
    @Published var mapViewModel: MapTabViewModel = .init()
    var settingsViewModel: SettingsViewModel = .init()
}
