//
//  HomeViewModel+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/11/23.
//

import Foundation
import SwiftUI
import CoreLocation
import GoogleMaps

// MARK: - ClickActions
extension MapTabViewModel {
    func onClickpickLocationPointOnMap() {
        self.removeMarkers()
        
        if let to = self.toLocation {
            self.editingDestinationId = to.id
        }
        
        withAnimation {
            self.state = .pickLocation
            if let toLocation {
                focusToLocation(toLocation.location)
            }
        }
    }
    
    func onClickSettings() {
        self.route = .settings
    }
    
    func onClickNotification() {
        self.route = .notifications
    }
    
    func onClickBack() {
        if self._lastState == .routing {
            self.state = .routing
            
            if !self.tryResetMarkers() {
                self.filterStationsByRoute()
            }
            
            return
        } else {
            withAnimation {
                self.state = .default

                self.clearDestination()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.startFilterStations()
                }
            }
        }
    }
    
    func drawAndFilterStations() async {
        await MainActor.run {
            self.isDrawing = true
        }
        
        await drawRoute().ifTrue {
            self.filterStationsByRoute()
        }
        
        await MainActor.run {
            self.isDrawing = false
        }
    }
    
    @discardableResult
    func drawRoute() async -> Bool {
        await MainActor.run {
            self.mapRoute = []
            
            self.showLoader(message: "searching.route".localize)
        }
        
        let searchResult = await interactor.searchRoute(
            addresses: destinations.map({$0.location})
        )
        
        guard let result = searchResult.0 else {
            await MainActor.run {
                self.hideLoader()
                self.showAlert(message: searchResult.1?.localizedDescription ?? "Cannot draw route")
                self.onClickResetMap()
            }
            try? await Task.sleep(for: .seconds(2))
            return false
        }
        
        await MainActor.run {
            self.mapRoute = result.locations.map(
                {.init(latitude: $0.lat, longitude: $0.lng)}
            )
            
            MapTabUtils.shared.mapPoints = self.destinations
            
            self.delegate?.onLoadTollCost(viewModel: self, result.toll)
            self.hideLoader()
        }
        
        try? await Task.sleep(for: .milliseconds(300))
        return true
    }
    
    func onClickSearchAddressFrom() {
        self.searchAddressViewModel.delegate = self
        
        if let loc = self.fromLocation {
            self.editingDestinationId = loc.id
            self.searchAddressViewModel.set(input: loc)
        }
        
        self.presentableRoute = .searchAddress(viewModel: self.searchAddressViewModel)
    }
    
    func onClickSearchAddressTo() {
        self.searchAddressViewModel.delegate = self
        
        if let edit = self.toLocation {
            self.editingDestinationId = edit.id
            self.searchAddressViewModel.set(input: edit)
        }
        
        self.presentableRoute = .searchAddress(viewModel: self.searchAddressViewModel)
    }
    
    func onClickFromLocation() {
        guard let fromLocation = fromLocation?.location else {
            return
        }
        
        focusToLocation(fromLocation)
    }
    
    func onClickToLocation() {
        guard let toLocation = toLocation?.location else {
            return
        }
        
        focusToLocation(toLocation)
    }
}

// MARK: - Filter methods
extension MapTabViewModel {
    
    func setupMarkers() {
        guard !stations.isEmpty else {
            return
        }
        
        DispatchQueue.main.async {
            self.stations.map({$0.asMarker}).forEach { marker in
                self.stationsMarkers.insert(marker)
            }
        }
        
        Logging.l(tag: "MapTabViewModel", "Setup all markers")
    }
    
    func removeStations() {
        guard !stations.isEmpty else {
            return
        }
        
        self.stations.removeAll()
        Logging.l(tag: "MapTabViewModel", "Remove all stations")
    }
    
    func removeMarkers() {
        guard !stationsMarkers.isEmpty else {
            return
        }
        
        stationsMarkers.forEach { marker in
            marker.map = nil
        }
        stationsMarkers.removeAll()
        Logging.l(tag: "MapTabViewModel", "Remove all markers")
    }
}
