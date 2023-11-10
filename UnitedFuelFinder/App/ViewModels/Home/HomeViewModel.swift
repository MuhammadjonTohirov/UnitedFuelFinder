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
        case .stationDetails:
            return "stationDetailsmghv bn "
        }
    }
    
    case settings
    case stationDetails
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .settings:
            SettingsView()
        case .stationDetails:
            StationDetailsView()
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
        case .searchAddress:
            return "search_address"
        }
    }
    
    case allStations(_ stations: [StationItem], _ from: String?, _ to: String?, _ radius: String?)
    case searchAddress(_ completion: (SearchAddressViewModel.SearchAddressResult) -> Void)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .allStations(let stations, let from, let to, let radius):
            AllStationsView(from: from, to: to, radius: radius, stations: stations)
        case .searchAddress(let completion):
            SearchAddressView(onResult: completion)
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
    @Published var stationsMarkers: [GMSMarker] = []
    
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
        
        didAppear = true
        
        //Will be executed if the screen is presented for the first time
        locationManager.requestLocationPermission()
        
        locationManager.startUpdatingLocation()
        
        locationManager.locationUpdateHandler = { [weak self] newLocation in
            
        }
                
        focusToCurrentLocation()
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
        
        self.showLoader(message: "detecting_address".localize)
        
        locationManager.getAddressFromLatLon(latitude: loc.latitude, longitude: loc.longitude) { address in
            self.hideLoader()
            if self.state == .selectFrom {
                self.fromAddress = address
            } else {
                self.toAddress = address
            }
        }
        
        if state == .selectFrom {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.filterStationsByDefault()
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
            
            guard let c = pickedLocation?.coordinate, state == .selectFrom else {
                return
            }

            let stations = await MainService.shared.filterStations(atLocation: (c.latitude, c.longitude), in: 10)
            Logging.l("Number of stations at \(c) in radius \(10) is \(stations.count)")
                        
            await MainActor.run {
                self.stations = stations.sorted(by: {$0.distance(from: self.locationManager.currentLocation?.coordinate ?? .init()) < $1.distance(from: self.locationManager.currentLocation?.coordinate ?? .init())})
                self.stationsMarkers = self.stations.map({$0.asMarker})
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
    
    func setupFromAddress(with res: SearchAddressViewModel.SearchAddressResult) {
        self.fromLocation = .init(latitude: res.lat, longitude: res.lng)
        self.fromAddress = res.address
        self.focusToLocation(self.fromLocation!)
    }
    
    func setupToAddress(with res: SearchAddressViewModel.SearchAddressResult) {
        self.toLocation = .init(latitude: res.lat, longitude: res.lng)
        self.toAddress = res.address
        self.onClickDrawRoute()
    }
}
