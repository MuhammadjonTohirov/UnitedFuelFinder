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

enum HomeBodyState: Int {
    case map = 0
    case list
}

protocol MapTabViewModelProtocl: ObservableObject {
    var route: MapTabRouter? {get set}
    var filter: MapFilterInput? {get}
    var isFilteringStations: Bool {get set}
    var isLoading: Bool {get set}
    
    func set(currentLocation location: CLLocation?)
    func set(filter: MapFilterInput)
}

final class MapTabViewModel: ObservableObject, MapTabViewModelProtocl {
    @Published var focusableLocation: CLLocation?
    @Published var filter: MapFilterInput?
    
    var isMapReady: Bool = false
    
    private(set) var interactor: any MapTabInteractorProtocol = MapTabInteractor(routeSearcher: ServerRouteSearcher())
    
    var fromAddress: String = ""
    var toAddress: String = ""
    
    var route: MapTabRouter? {
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
    
    var didDisappear: Bool = false
    
    @Published var push: Bool = false
    
    @Published var present: Bool = false
    
    @Published var pickedLocation: CLLocation?

    @Published var isLoading: Bool = false
    @Published var isLoadingAddress: Bool = false
    
    @Published var isFilteringStations: Bool = false
    
    @Published var isDragging: Bool = false
    @Published var isDrawing: Bool = false
    @Published var mapRoute: [CLLocationCoordinate2D] = []
    @Published var isDetectingAddressFrom: Bool = false
    @Published var isDetectingAddressTo: Bool = false
    
    private(set) var loadingMessage: String = ""
    private(set) var customers: [CustomerItem] = []
    
    var screenVisibleArea: CGFloat = 5
    
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

    @Published var stations: [StationItem] = []
    
    @Published var stationsMarkers: Set<GMSMarker> = []
    
    private var loadStationsTask: DispatchWorkItem?
    
    private(set) var lastCurrentLocation: CLLocation?
    
    var distance: String {
        guard let from = fromLocation, let to = toLocation else {
            return ""
        }
        
        let distance = locationManager.distance(from: from.coordinate, to: to.coordinate).f.asMile
        return String(format: "%.1f ml",  distance)
    }
    
    private let locationManager: GLocationManager = .shared
    
    func onAppear() {
        if filter == nil {
            self.filter = .init(
                sortType: .distance,
                from: 0,
                to: 1000,
                radius: UserSettings.shared.maxRadius,
                selectedStations: Set(DCustomer.all?.compactMap({$0.id}) ?? [])
            )
        }
        
        didDisappear = false
        //Always be exectued
        
        self.loadCustomers()
        
        guard !didAppear else {
            onReappear()
            return
        }
        
        didAppear = true
                
        self.focusToCurrentLocation()
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 0.5) {
            Task {
                await MainActor.run {
                    self.focusToCurrentLocation()
                }
                
                await MainActor.run {
                    self.restoreSavedRoute()
                }
            }
        }
    }
    
    private func onReappear() {
        switch state {
        case .selectFrom:
            if self.stations.isEmpty {
                self.filterStationsByDefault()
            }
            
            if self.stationsMarkers.isEmpty && !self.stations.isEmpty {
                self.setupMarkers()
            }
            
        case .routing:
            if self.stations.isEmpty {
                self.onClickDrawRoute()
            } else {
                self.setupMarkers()
            }
        default:
            break
        }
    }
    
    func set(currentLocation location: CLLocation?) {
        if self.lastCurrentLocation == nil {
            self.lastCurrentLocation = location
            self.focusToCurrentLocation()
        }
    }
    
    func set(filter: MapFilterInput) {
        mainIfNeeded {
            self.filter = filter
            self.removeMarkers()
            self.removeStations()
            switch self.state {
            case .routing:
                self.filterStationsByRoute()
            case .selectFrom:
                self.filterStationsByDefault()
            default:
                break
            }
        }
    }
    
    func onDisappear() {
        didDisappear = true
        removeMarkers()
    }
    
    private func restoreSavedRoute() {
        if let des = UserSettings.shared.destination, let from = UserSettings.shared.fromLocation {
            self.fromLocation = from.location
            self.toLocation = des.location
            
            GLocationManager.shared.getAddressFromLatLon(
                latitude: from.latitude,
                longitude: from.longitude) 
            { [weak self] address in
                self?.fromAddress = address
            }

            GLocationManager.shared.getAddressFromLatLon(
                latitude: des.latitude,
                longitude: des.longitude
            ) { [weak self] address in
                self?.toAddress = address
                
                self?.onClickDrawRoute()
            }
        }
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
        mainIfNeeded {
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
            self.fromLocation = pickedLocation
            self.isDetectingAddressFrom = true
        case .selectTo:
            self.toLocation = pickedLocation
            self.isDetectingAddressTo = true
        case .routing:
            break
        }
        
        locationManager.getAddressFromLatLon(
            latitude: loc.latitude,
            longitude: loc.longitude
        ) { address in
            if self.state == .selectFrom {
                self.fromAddress = address
            } else if self.state == .selectTo {
                self.toAddress = address
            }
            
            DispatchQueue.main.async {
                self.isDetectingAddressTo = false
                self.isDetectingAddressFrom = false
            }
        }
    }
    
    func startFilterStations() {
        if didDisappear {
            return
        }
        
        self.filterStationsByDefault()
    }
    
    func clearDestination() {
        mainIfNeeded {
            self.hasDrawen = false
            self.toAddress = ""
            self.mapRoute = []
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
        
        if self.state == .routing {
            mapRoute = []
            onClickDrawRoute()
            return
        }
        
        self.focusToLocation(self.fromLocation!)
    }
    
    func setupToAddress(with res: SearchAddressViewModel.SearchAddressResult) {
        self.toLocation = .init(latitude: res.lat, longitude: res.lng)
        self.toAddress = res.address
        UserSettings.shared.destination = .init(latitude: res.lat, longitude: res.lng)
        self.onClickDrawRoute()
    }
    
    func loadCustomers() {
        self.customers = DCustomer.all?.compactMap({$0.asModel}) ?? []
    }
    
    func onSelectMap() {
        self.setupMarkers()
        
        if state == .routing && !mapRoute.isEmpty {
            return
        }
        
        guard self.fromLocation == nil || self.toLocation == nil else {
            return
        }
        
        if let loc = self.pickedLocation {
            self.focusToLocation(loc)
        } else {
            self.focusToCurrentLocation()
        }
    }
    
    func onSelectList() {
        self.removeMarkers()
    }
}
