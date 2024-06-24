//
//  HomeRouter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/12/23.
//

import Foundation
import SwiftUI
import CoreLocation

enum MapTabRouter: ScreenRoute {
    static func == (lhs: MapTabRouter, rhs: MapTabRouter) -> Bool {
        lhs.id == rhs.id
    }
    
    var id: String {
        switch self {
        case .settings:
            return "settings"
        case .stationDetails:
            return "stationDetails"
        case .notifications:
            return "notifications"
        case .filter:
            return "filter"
        case .destinations:
            return "destinations"
        }
    }
    
    case settings
    case stationDetails(station: StationItem)
    case notifications
    case filter(_ input: MapFilterInput, _ completion: (MapFilterInput) -> Void)
    case destinations(viewModel: DestinationsViewModel)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .settings:
            SettingsView()
        case .stationDetails(let station):
            StationDetailsView(station: station)
        case .notifications:
            NotificationsView()
        case let .filter(input, completion):
            MapFilterView(input: input, completion: completion)
        case .destinations(let viewModel):
            DestinationsView()
                .environmentObject(viewModel)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum HomePresentableSheets: ScreenRoute {
    static func == (lhs: HomePresentableSheets, rhs: HomePresentableSheets) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        switch self {
        case .searchAddress:
            return "search_address"
        }
    }
    
    case searchAddress(viewModel: SearchAddressViewModel)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .searchAddress(let vm):
            SearchAddressView()
                .environmentObject(vm)
        }
    }
}
