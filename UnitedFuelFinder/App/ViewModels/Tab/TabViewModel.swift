//
//  TabViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import CoreLocation

class TabViewModel: ObservableObject {
    @Published var selectedTag: MainTabs = .dashboard
    
    @Published var dashboardViewModel: any DashboardViewModelProtocol = DashboardViewModel()
    @Published var mapViewModel: any MapTabViewModelProtocl = MapTabViewModel()
    @Published var settingsViewModel: SettingsViewModel = .init()
    
    @Published var discountedStations: [StationItem] = []
    private var lastLocationUpdate: Date = .now.before(days: 1)
    
    func onAppear() {
        setupLocation()
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
    
    func loadDiscountedStations(_ currentLocation: CLLocation?) async {
        guard let c = currentLocation?.coordinate else {
            return
        }
        
        let _stations = await MainService.shared.discountedStations(
            atLocation: (c.latitude, c.longitude),
            in: 10,
            limit: 10
        ).sorted(
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
            
            try await Task.sleep(for: .seconds(1))
            if let serverVersion = await CommonService.shared.getVersion() {
                UserSettings.shared.currentAPIVersion = serverVersion
            }
        }
    }
}
