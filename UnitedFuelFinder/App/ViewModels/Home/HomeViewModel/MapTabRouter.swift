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
            return "stationDetailsmghv bn "
        case .notifications:
            return "notifications"
        case .filter:
            return "filter"
        }
    }
    
    case settings
    case stationDetails(station: StationItem)
    case notifications
    case filter(_ input: MapFilterInput, _ completion: (MapFilterInput) -> Void)
    
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
        case .allStations:
            return "all_stations"
        case .searchAddress:
            return "search_address"
        }
    }
    
    case allStations(stations: [StationItem], from: String?, to: String?, radius: Int?, location: CLLocationCoordinate2D?, onNavigation: ((StationItem) -> Void)?, onClickItem: ((StationItem) -> Void)?)
    case searchAddress(text: String, _ completion: (SearchAddressViewModel.SearchAddressResult) -> Void)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .allStations(let stations, let from, let to, let radius, let location, let onNav, let onOpen):
            AllStationsView(from: from, to: to, location: location, radius: radius, onClickNavigate: onNav, onClickOpen: onOpen, stations: stations)
        case .searchAddress(let text, let completion):
            SearchAddressView(text: text, onResult: completion)
        }
    }
}
