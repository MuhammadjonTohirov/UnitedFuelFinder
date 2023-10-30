//
//  HomeViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import CoreLocation
import GoogleMaps
import SwiftUI

enum HomeViewState {
    case selectFrom // or we can say default state
    case selectTo   
    case routing
}

enum HomeRouter: ScreenRoute {
    var id: String {
        switch self {
        case .settings:
            return "settings"
        }
    }
    
    case settings
    
    var screen: some View {
        switch self {
        case .settings:
            SettingsView()
        }
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
        }
    }
    
    case allStations(_ stations: [StationItem], _ from: String?, _ to: String?, _ radius: String?)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .allStations(let stations, let from, let to, let radius):
            AllStationsView(from: from, to: to, radius: radius, stations: stations)
        }
    }
}

final class HomeViewModel: ObservableObject {
    @Published var currentLocation: CLLocation?
    
    var fromAddress: String = ""
    var toAddress: String = ""
    
    var route: HomeRouter? {
        didSet {
            DispatchQueue.main.async {
                self.push = self.route != nil
            }
        }
    }
    
    var presentableRoute: HomePresentableSheets? {
        didSet {
            DispatchQueue.main.async {
                self.present = self.presentableRoute != nil
            }
        }
    }
    
    private var didAppear: Bool = false
    
    @Published var push: Bool = false
    
    @Published var present: Bool = false
    
    @Published var pickedLocation: CLLocation?

    @Published private(set) var isLoading: Bool = false

    @Published var isDetectingAddress: Bool = false
    
    private(set) var loadingMessage: String = ""
    
    @Published var state: HomeViewState = .selectFrom
        
    private(set) var hasDrawen: Bool = false
    private(set) var fromLocation: CLLocation?
    private(set) var toLocation: CLLocation?
    private(set) var toLocationCandidate: CLLocation?
    
    @Published var stations: [StationItem] = []
    
    var distance: String {
        guard let from = fromLocation, let to = toLocation else {
            return ""
        }
        
        let distance = locationManager.distance(from: from.coordinate, to: to.coordinate)
        let isMore1000 = Int(distance) / 1000 > 0
        let unit = isMore1000 ? "km" : "m"
        return String(format: "%.1f \(unit)",  isMore1000 ? distance / 1000 : distance)
    }
    
    private let locationManager: GLocationManager = .shared
    
    func onAppear() {
        //Always be exectued
        guard !didAppear else {
            return
        }
        //Will be executed if the screen is presented for the first time
        locationManager.requestLocationPermission()
        
        locationManager.startUpdatingLocation()
        
        locationManager.locationUpdateHandler = { [weak self] newLocation in
        
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.filterStationsByDefault()
        }
    }
    
    func focusToCurrentLocation() {
        guard let location = self.locationManager.currentLocation else {
            return
        }
        
        Logging.l("Current location \(location.coordinate)")
        
        focusToLocation(location)
    }
    
    func focusToLocation(_ location: CLLocation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.currentLocation = location
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.currentLocation = nil
            }
        }
    }
    
    func reloadAddress() {
        guard let loc = pickedLocation?.coordinate else {
            return
        }
        switch self.state {
        case .selectFrom:
            self.fromLocation = pickedLocation
        case .selectTo:
            self.toLocation = pickedLocation
        case .routing:
            break
        }
        
        self.showLoader(message: "finding_route".localize)
        
        locationManager.getAddressFromLatLon(latitude: loc.latitude, longitude: loc.longitude) { address in
            DispatchQueue.main.async {
                self.hideLoader()
                if self.state == .selectFrom {
                    self.fromAddress = address
                } else {
                    self.toAddress = address
                }
            }
        }
    }
    
    func onClickSelectToPointOnMap() {
        withAnimation {
            self.state = .selectTo
            if let toLocation {
                focusToLocation(toLocation)
            }
        }
    }
    
    func onClickSettings() {
        self.route = .settings
    }
    
    func onClickViewAllStations() {
        self.presentableRoute = .allStations(self.stations, nil, nil, "25 km")
    }
    
    func onClickBack() {
        withAnimation {
            self.state = .selectFrom
            if let fromLocation {
                focusToLocation(fromLocation)
            }
        }
    }
    
    func onClickDrawRoute() {
        withAnimation {
            self.state = .routing
        }
    }
    
    func clearDestination() {
        DispatchQueue.main.async {
            self.hasDrawen = false
            self.toAddress = ""
            self.toLocation = nil
        }
    }
    
    func onStartDrawingRoute() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    func onEndDrawingRoute() {
        DispatchQueue.main.async {
            self.isLoading = false
            self.hasDrawen = true
        }
    }
    
    func filterStations() {
        if toLocation == nil {
            filterStationsByDefault()
            return
        }
        
        filterStationsByRoute()
    }
    
    private func filterStationsByRoute() {
//        TODO: - Implement
    }
    
    private func filterStationsByDefault() {
        stations = []
        Task {
            self.showLoader(message: "loading_stations".localize)

            await AuthService.shared.syncUserInfo()

            Logging.l("Start loading stations")

            guard let user = UserSettings.shared.userInfo else {
                return
            }

            let stations = await MainService.shared.findStations(atCity: "\(user.city)")
            Logging.l("Number of stations in \(user.city) \(stations.count)")
            await MainActor.run {
                self.stations = stations.sorted(by: {$0.distance(from: self.locationManager.currentLocation?.coordinate ?? .init()) < $1.distance(from: self.locationManager.currentLocation?.coordinate ?? .init())})
            }
            
            self.hideLoader()
        }
    }
    
    func showLoader(message: String) {
        DispatchQueue.main.async {
            self.loadingMessage = message
            self.isLoading = true
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loadingMessage = ""
            self.isLoading = false
        }
    }
}