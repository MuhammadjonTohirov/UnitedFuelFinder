//
//  TabViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import CoreLocation

class MainTabViewModel: ObservableObject {
    @Published var selectedTag: MainTabs = .dashboard
    
    @Published var dashboardViewModel: any DashboardViewModelProtocol = DashboardViewModel()
    @Published var mapViewModel: any MapTabViewModelProtocl = MapTabViewModel()
    @Published var settingsViewModel: SettingsViewModel = .init()
    
    @Published var isLoading: Bool = false
    @Published var discountedStations: [StationItem] = []
    @Published var showWarningAlert: Bool = false
    private var lastLocationUpdate: Date = .now.before(days: 1)
    private var didAppear: Bool = false
    func onAppear() {
        if didAppear {
            return
        }
        
        setupLocation()
        
        isLoading = true
        
        didAppear = true
        Task {
            await MainService.shared.syncAllStations()
            
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func setupLocation() {
        guard GLocationManager.shared.locationUpdateHandler == nil else {
            return
        }
        
        setupSyncVersion()
        
        GLocationManager.shared.requestLocationPermission()
        
        if let loc = GLocationManager.shared.currentLocation {
            onLocationChange(loc)
        }
        
        GLocationManager.shared.locationUpdateHandler = { [weak self] location in
            self?.onLocationChange(location)
        }
        
        GLocationManager.shared.startUpdatingLocation()
    }
    
    func onSelectMapTab() {
        mainIfNeeded {
            self.mapViewModel.set(currentLocation: GLocationManager.shared.currentLocation)
        }
    }
    
    private func onLocationChange(_ location: CLLocation) {
        guard lastLocationUpdate.addingTimeInterval(20) < .now else {
            return
        }
        
        self.dashboardViewModel.setCurrentLocation(location)
        
        self.lastLocationUpdate = Date()
        
        Task {
            await loadDiscountedStations(location)
        }
    }
    
    func alertWarning() {
        showWarningAlert = true
    }
    
    func loadDiscountedStations(_ currentLocation: CLLocation?) async {
        guard let c = currentLocation?.coordinate, selectedTag == .dashboard else {
            return
        }
        
        let (_stations) = await MainService.shared.filterStations2(
            req: .init(current: .init(lat: c.latitude, lng: c.longitude), distance: 10)
        ).0.sorted(
            by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation}
        )
        
        await MainActor.run {
            debugPrint("Discounted stations \(_stations.count)")
            self.discountedStations = _stations
            
            switch self.selectedTag {
            case .dashboard:
                self.dashboardViewModel.setDiscounted(stations: _stations)
            case .map:
                break
            case .settings:
                break
            }
        }
    }
    
    private func setupSyncVersion() {
        Task {
            await AuthService.shared.syncUserInfo()
            
            if let serverVersion = await CommonService.shared.getVersion() {
                UserSettings.shared.currentAPIVersion = serverVersion
            }
        }
    }
}
