//
//  HomeViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import GoogleMaps

enum HomeViewState {
    case selectFrom // or we can say default state
    case selectTo   
    case routing
}

final class HomeViewModel: ObservableObject {
    @Published var focusableLocation: CLLocation?
    
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
    
    @Published var radius: CLLocationDistance = 2
    @Published var radiusValue: CGFloat = 2
    
    private(set) var loadingMessage: String = ""
    private(set) var customers: [CustomerItem] = []
    
    @Published var state: HomeViewState = .selectFrom {
        didSet {
            Logging.l(tag: "HomeViewModel", "State \(state)")
        }
    }
        
    var hasDrawen: Bool = false
    var fromLocation: CLLocation? {
        didSet {
            Logging.l(tag: "HomeViewModel", "Set from location \(fromLocation?.coordinate ?? .init(latitude: 0, longitude: 0))")
        }
    }
    
    var toLocation: CLLocation? {
        didSet {
            if let l = toLocation {
                UserSettings.shared.destination = .init(latitude: l.coordinate.latitude, longitude: l.coordinate.longitude)
            } else {
                UserSettings.shared.destination = nil
            }
        }
    }
    var toLocationCandidate: CLLocation?
    private(set) var timer: Timer?
    @Published var stations: [StationItem] = []
    @Published var discountedStations: [StationItem] = []
    @Published var stationsMarkers: [GMSMarker] = []
    
    private var loadStationsTask: DispatchWorkItem?
    
    private(set) var lastCurrentLocation: CLLocation?
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
        
        locationManager.locationUpdateHandler = { [weak self] location in
            guard let self = self else {
                return
            }
            
            if self.lastCurrentLocation == nil {
                self.lastCurrentLocation = location
            }
        }
        
        //Will be executed if the screen is presented for the first time
        locationManager.requestLocationPermission()
        
        locationManager.startUpdatingLocation()
        
        if UserSettings.shared.destination == nil || UserSettings.shared.fromLocation == nil {
            focusToCurrentLocation()
        }
        
        loadCustomers()
        
        startRegularFetchingNearStations()
        
        restoreSavedRoute()
    }
    
    private func restoreSavedRoute() {
        if let des = UserSettings.shared.destination, let from = UserSettings.shared.fromLocation {
            self.fromLocation = from.location
            self.toLocation = des.location
            self.onClickDrawRoute()

            GLocationManager.shared.getAddressFromLatLon(latitude: des.latitude, longitude: des.longitude) { address in
                self.toAddress = address
            }
        }
    }
    
    private func startRegularFetchingNearStations() {
        timer?.invalidate()
        
        timer = .scheduledTimer(withTimeInterval: 5, repeats: true, block: { _ in
            self.startFilterStations()
        })
    }
    
    func focusToCurrentLocation() {
        guard let location = self.locationManager.currentLocation else {
            return
        }
        
        self.lastCurrentLocation = location
        Logging.l("Current location \(location.coordinate)")
        
        focusToLocation(location)
    }
    
    func focusToLocation(_ location: CLLocation) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.focusableLocation = location
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.focusableLocation = nil
            }
        }
    }
    
    func reloadAddress() {
        guard let loc = pickedLocation?.coordinate else {
            return
        }
        
        switch self.state {
        case .selectFrom:
            if UserSettings.shared.destination == nil {
                self.fromLocation = pickedLocation
                self.isDetectingAddressFrom = true
                UserSettings.shared.fromLocation = .init(latitude: loc.latitude, longitude: loc.longitude)
            }
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

        if state == .routing {
            filterStationsByRoute()
        }
    }
    
    func startFilterStations() {
        self.radius = self.radiusValue
        self.filterStationsByDefault()
    }
    
    func clearDestination() {
        mainIfNeeded {
            self.hasDrawen = false
            self.toAddress = ""
            self.toLocation = nil
            UserSettings.shared.destination = nil
            UserSettings.shared.fromLocation = nil
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
                self.toAddress = ""
                self.toLocation = nil
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
        UserSettings.shared.destination = .init(latitude: res.lat, longitude: res.lng)
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

