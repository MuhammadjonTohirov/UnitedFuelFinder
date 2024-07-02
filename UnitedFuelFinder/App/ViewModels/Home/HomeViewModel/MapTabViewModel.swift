//
//  HomeViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import GoogleMaps

protocol MapTabViewModelDelegate: AnyObject {
    func onLoadTollCost(viewModel: MapTabViewModel, _ toll: Float)
    func onResetMap(viewModel: MapTabViewModel)
}

final class MapTabViewModel: NSObject, ObservableObject, MapTabViewModelProtocl, Alertable {
    @Published var focusableLocation: CLLocation?
    @Published var filter: MapFilterInput?
    
    @Published var searchAddressViewModel = SearchAddressViewModel()
    @Published var destinationsViewModel = DestinationsViewModel()
    
    @Published var shouldShowAlert: Bool = false
    
    var pointLabel: Character {
        if destinations.isEmpty {
            return "A"
        }
        
        if destinations.count == 1 && state == .default {
            return "A"
        }
        
        if destinations.count == 1 && state == .pickLocation {
            return "B"
        }
        
        return destinations.count.label
    }
    
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    weak var delegate: MapTabViewModelDelegate?
    
    var filterTask: Task<Void, Never>?
    
    var isMapReady: Bool = false
    
    private(set) var interactor: any MapTabInteractorProtocol = MapTabInteractor(
        routeSearcher: ServerRouteSearcher()
    )
    
    var fromLocation: MapDestination? {
        destinations.first
    }
    
    var toLocation: MapDestination? {
        destinations.count == 1 ? nil : destinations.last
    }
    
    var fromAddress: String {
        destinations.first?.address ?? ""
    }
    var toAddress: String {
        destinations.count == 1 ? "" : (destinations.last?.address ?? "")
    }
    
    var currentDestination: MapDestination?
    
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
    
    private(set) var didAppear: Bool = false
    
    private(set) var didDisappear: Bool = false
    
    @Published var push: Bool = false
    
    @Published var present: Bool = false
    
    @Published var pickedLocation: CLLocation?
    @Published var pickedLocationAddress: String?

    @Published var isLoading: Bool = false
    @Published var isLoadingAddress: Bool = false
    
    @Published var isFilteringStations: Bool = false
    
    @Published var isDragging: Bool = false
    @Published var isDrawing: Bool = false
    
    @Published var mapRoute: [CLLocationCoordinate2D] = []
    
    @Published var isDetectingAddressFrom: Bool = false
    @Published var isDetectingAddressTo: Bool = false
        
    var editingDestinationId: String?
    private(set) var loadingMessage: String = ""
    private(set) var customers: [CustomerItem] = []
    
    var screenVisibleArea: CGFloat = 5
    
    private(set) var _lastState: HomeViewState = .default
    
    @Published var state: HomeViewState = .default {
        didSet {
            Logging.l(tag: "HomeViewModel", "State \(state)")
            self._lastState = oldValue
        }
    }
        
    var hasDrawen: Bool = false
    
    @Published var destinations: [MapDestination] = []
    
    @Published var stations: [StationItem] = []
    
    @Published var stationsMarkers: Set<GMSMarker> = []
    
    private(set) var lastCurrentLocation: CLLocation?
    
    var distance: String {
        guard destinations.count > 1, let from = destinations.first?.location, let to = destinations.last?.location else {
            return ""
        }
        
        let distance = locationManager.distance(from: from, to: to).f.asMile
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isMapReady = MapTabUtils.shared.mapPoints?.isEmpty ?? true

            self.focusToCurrentLocation()
        }
        
        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + 1) {
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
        case .default:
            if self.stations.isEmpty {
                self.filterStationsByDefault()
            }
            
            if self.stationsMarkers.isEmpty && !self.stations.isEmpty {
                self.setupMarkers()
            }
            
        case .routing:
            if self.stations.isEmpty {
                if !destinations.isEmpty {
                    Task {
                        await self.drawRoute()
                        self.startFilterStations()
                    }
                }
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
            self.startFilterStations()
        }
    }
    
    func onDisappear() {
        self.didDisappear = true
        self.removeMarkers()
    }
    
    private func restoreSavedRoute() {
        guard let savedDestinations = MapTabUtils.shared.mapPoints, !savedDestinations.isEmpty else {
            return
        }
        
        self.state = .routing
        self.mapRoute = []
        self.removeMarkers()
        self.removeStations()
        
        self.destinations = savedDestinations
        
        Task.detached(priority: .high) { [weak self] in
            await self?.drawAndFilterStations()
            
            await MainActor.run { [weak self] in
                self?.isMapReady = true
            }
        }
    }
    
    func focusToCurrentLocation() {
        guard let location = self.locationManager.currentLocation else {
            return
        }
        
        self.lastCurrentLocation = location
        
        Logging.l("Current location \(location.coordinate)")
        
        focusToLocation(location.coordinate)
    }
    
    func focusToLocation(_ location: CLLocationCoordinate2D) {
        mainIfNeeded {
            self.focusableLocation = .init(
                latitude: location.latitude,
                longitude: location.longitude
            )
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.focusableLocation = nil
            }
        }
    }
    
    func startFilterStations() {
        if didDisappear {
            return
        }
        
        if state == .default {
            self.filterStationsByDefault()
        }
        
        if state == .routing {
            self.filterStationsByRoute()
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
                self.state = .default

                self.removeMarkers()
                self.removeStations()
                self.removeDestinations()
                
                self.startFilterStations()
            }
        }
    }
    
    func showLoader(message: String) {
        mainIfNeeded {
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
            self.focusToLocation(loc.coordinate)
        } else {
            self.focusToCurrentLocation()
        }
    }
    
    func onSelectList() {
        self.removeMarkers()
    }
    
    func navigate(to station: StationItem) {
        let point = (station.lat, station.lng)
        // open on maps
        GLocationManager.shared.openLocationOnMap(.init(latitude: point.0, longitude: point.1), name: station.name)
    }
}
