//
//  TabViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/02/24.
//

import Foundation
import CoreLocation
import UIKit

struct MapTabDetail {
    var tollCost: Float
}

class MainTabViewModel: ObservableObject {
    @Published var selectedTag: MainTabs = .settings
    
    let dashboardViewModel: any DashboardViewModelProtocol = DashboardViewModel()
    let mapViewModel: any MapTabViewModelProtocl = MapTabViewModel()
    let settingsViewModel: SettingsViewModel = .init()

    @Published var isLoading: Bool = false
    @Published var discountedStations: [StationItem] = []
    @Published var showWarningAlert: Bool = false
    @Published var showVersionWarningAlert: Bool = false
    @Published var leadningNavigationOpacity: CGFloat = 1
    @Published var mapBodyState: HomeBodyState = .map
    @Published var mapDetails: MapTabDetail?
    
    private var lastLocationUpdate: Date = .now.before(days: 1)
    private var didAppear: Bool = false
    func onAppear() {
        if didAppear {
            return
        }
        
        mapViewModel.delegate = self

        setupLocation()
        
        isLoading = true
        
        didAppear = true
        
        Task.detached(priority: .high) { [weak self] in
            await MainService.shared.syncAllStations()
            
            await MainActor.run { [weak self] in
                self?.isLoading = false
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
        
//        MARK: this no need to load discounted stations anymore
//        Task {
//            await loadDiscountedStations(location)
//        }
    }
    
    func alertWarning() {
        showWarningAlert = true
    }
    func checkActualVersion() {
        if showWarningAlert{
            return
        }
        let version = Bundle.main.appVersion
        let actualVersion = UserSettings.shared.actualAppVersion
        if actualVersion != nil {
            if actualVersion != version{
                showVersionWarningAlert = true
            }
        }
    }
    func showAppOnAppstore() {        
        let url = "https://itunes.apple.com/app/id\(URL.appstoreID)"
        guard let url = URL(string: url) else { return }
        UIApplication.shared.open(url)
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
            
//            if let serverVersion = await CommonService.shared.getVersion() {
//                UserSettings.shared.currentAPIVersion = serverVersion
//            }
        }
    }
    private func getActualVersion() async {
        fatalError("Do not use this method")
//        Task {
//            if let version = await CommonService.shared.getActualVersion(){
//                UserSettings.shared.actualAppVersion = version
//                checkActualVersion()
//            }
//        }
    }
}

extension MainTabViewModel: MapTabViewModelDelegate {
    func onLoadTollCost(viewModel: MapTabViewModel, _ toll: Float) {
        self.mapDetails = .init(tollCost: toll)
    }
    
    func onResetMap(viewModel: MapTabViewModel) {
        self.mapDetails = nil
    }
}
