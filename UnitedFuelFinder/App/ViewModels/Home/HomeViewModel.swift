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
    case searchAddress(_ completion: (SearchAddressViewModel.SearchAddressResult) -> Void)
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .allStations(let stations, let from, let to, let radius, let location, let onNav, let onOpen):
            AllStationsView(from: from, to: to, location: location, radius: radius, onClickNavigate: onNav, onClickOpen: onOpen, stations: stations)
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

    @Published var isLoading: Bool = false
    @Published var isDragging: Bool = false
    @Published var isDrawing: Bool = false
    @Published var isDetectingAddressFrom: Bool = false
    @Published var isDetectingAddressTo: Bool = false
    
    @Published var radius: CLLocationDistance = 20
    @Published var radiusValue: CGFloat = 20
    
    private(set) var loadingMessage: String = ""
    
    @Published var state: HomeViewState = .selectFrom
        
    private(set) var hasDrawen: Bool = false
    private(set) var fromLocation: CLLocation?
    private(set) var toLocation: CLLocation?
    private(set) var toLocationCandidate: CLLocation?
    
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
    
    func onEndDrawingRoute() {
        DispatchQueue.main.async {
            self.isDrawing = false
            self.hasDrawen = true
        }
        
        filterStationsByRoute()
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

extension HomeViewModel {
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
    
    func onClickNotification() {
        self.route = .notifications
    }
        
    func onClickViewAllStations() {
        self.presentableRoute = .allStations(
            stations: self.stations, from: nil, to: nil, radius: Int(radius),
            location: self.fromLocation?.coordinate, onNavigation: { sta in
                self.focusToLocation(sta.clLocation)
            }, onClickItem: { sta in
                self.route = .stationDetails(station: sta)
            })
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
}

extension StationItem {
    var clLocation: CLLocation {
        .init(latitude: lat, longitude: lng)
    }
}

extension HomeViewModel {
    private func filterStationsByRoute() {
        DispatchQueue.main.async {
            self.stations = []
        }
        
        Task {
            guard state == .routing, let toLocation, let fromLocation else {
                return
            }
            let f = (fromLocation.coordinate.latitude, fromLocation.coordinate.longitude)
            let t = (toLocation.coordinate.latitude, toLocation.coordinate.longitude)
            
            let _stations = await MainService.shared.filterStations(from: f, to: t, in: 10)
                .sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})
            
            await MainActor.run {
                self.stations = _stations
                self.stationsMarkers = self.stations.map({$0.asMarker})
            }
        }
    }
    
    private func filterStationsByDefault() {
        Task {
            self.showLoader(message: "loading_stations".localize)

            Logging.l(tag: "HomeViewModel", "Start loading stations")

            guard let c = pickedLocation?.coordinate, state == .selectFrom else {
                return
            }

            let _stations = await MainService.shared.filterStations(
                atLocation: (c.latitude, c.longitude),
                in: Int(radiusValue)
            ).sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})
            
            Logging.l(tag: "HomeViewModel", "Number of stations at \(c) in radius \(radiusValue) is \(stations.count)")
                    
            await MainActor.run {
                self.stationsMarkers.forEach { marker in
                    marker.map = nil
                }
                
                self.stationsMarkers.removeAll()

                let newStations = _stations.filter({station in
                    !self.stations.contains(where: {$0.id == station.id})
                })
                
                let oldStations = self.stations.filter({station in
                    !_stations.contains(where: {$0.id == station.id})
                })
            
                oldStations.forEach { station in
                    if let index = self.stations.firstIndex(where: {$0.id == station.id}) {
                        self.stations.remove(at: index)
                    }
                }
                
                withAnimation {
                    self.stations = newStations + self.stations
                    self.stationsMarkers = self.stations.map({$0.asMarker})
                }
            }
            
            self.hideLoader()
        }
    }
    
    private func filterStationsByDiscount() {
        Task {
            self.showLoader(message: "loading_stations".localize)

            Logging.l(tag: "HomeViewModel", "Start loading stations")

            guard let c = pickedLocation?.coordinate, state == .selectFrom else {
                return
            }

            let _stations = await MainService.shared.discountedStations(
                atLocation: (c.latitude, c.longitude),
                in: Int(radiusValue), limit: 7
            ).sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})

            await MainActor.run {
                self.discountedStations = _stations
            }
        }
    }
}
