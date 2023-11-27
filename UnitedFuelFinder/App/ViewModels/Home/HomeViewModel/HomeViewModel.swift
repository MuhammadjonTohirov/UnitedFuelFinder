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
    static func == (lhs: HomeRouter, rhs: HomeRouter) -> Bool {
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
        }
    }
    
    case settings
    case stationDetails(station: StationItem)
    case notifications
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .settings:
            SettingsView()
        case .stationDetails(let station):
            StationDetailsView(station: station)
        case .notifications:
            NotificationsView()
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

    @Published var isLoading: Bool = false
    @Published var isDragging: Bool = false
    @Published var isDrawing: Bool = false
    @Published var isDetectingAddressFrom: Bool = false
    @Published var isDetectingAddressTo: Bool = false
    
    @Published var radius: CLLocationDistance = 20
    @Published var radiusValue: CGFloat = 20
    
    private(set) var loadingMessage: String = ""
    private(set) var customers: [CustomerItem] = []
    
    @Published var state: HomeViewState = .selectFrom
        
    var hasDrawen: Bool = false
    var fromLocation: CLLocation?
    var toLocation: CLLocation?
    var toLocationCandidate: CLLocation?
    
    @Published var stations: [StationItem] = []
    @Published var discountedStations: [StationItem] = []
    @Published var stationsMarkers: [GMSMarker] = []
    
    private var loadStationsTask: DispatchWorkItem?
    
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
        
        focusToCurrentLocation()
        
        loadCustomers()
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
            self.isDetectingAddressFrom = true
        case .selectTo:
            self.toLocation = pickedLocation
            self.isDetectingAddressTo = true
        case .routing:
            break
        }
        
        locationManager.getAddressFromLatLon(latitude: loc.latitude, longitude: loc.longitude) { address in
            if self.state == .selectFrom {
                self.fromAddress = address
            } else {
                self.toAddress = address
            }
            
            DispatchQueue.main.async {
                self.isDetectingAddressTo = false
                self.isDetectingAddressFrom = false
            }
        }
        
        if state == .selectFrom {
            startFiltering()
        }
        
        if state == .routing {
            filterStationsByRoute()
        }
    }
    
    func startFiltering() {
        self.radius = self.radiusValue
        loadStationsTask?.cancel()

        loadStationsTask = .init(block: {
            if !self.isDragging && self.state == .selectFrom {
                self.filterStationsByDefault()
                self.filterStationsByDiscount()
            }
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: loadStationsTask!)
    }
    
    func clearDestination() {
        mainIfNeeded {
            self.hasDrawen = false
            self.toAddress = ""
            self.toLocation = nil
            self.stations = []
            self.stationsMarkers.forEach { marker in
                marker.map = nil
            }
            
            self.stationsMarkers.removeAll()
        }
    }
    
    func onStartDrawingRoute() {
        DispatchQueue.main.async {
            self.stationsMarkers.forEach { marker in
                marker.map = nil
            }
            
            self.stationsMarkers.removeAll()
            self.stations.removeAll()
            
            self.isDrawing = true
        }
    }
    
    func onEndDrawingRoute(_ isOK: Bool) {
        DispatchQueue.main.async {
            self.isDrawing = false
            self.hasDrawen = true
        }
        
        if isOK {
            filterStationsByRoute()
        } else {
            DispatchQueue.main.async {
                self.state = .selectFrom
            }
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
    
    func loadCustomers() {
        Task {
            let _customers = await MainService.shared.getCustomers()
            
            await MainActor.run {
                self.customers = _customers
            }
        }
    }
}

