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
    
    func drawRoute() async {
        await MainActor.run {
            self.mapRoute = []
            
            self.showLoader(message: "searching.route".localize)
        }
        
        guard let result = await interactor.searchRoute(
            addresses: destinations.map({$0.location})
        ) else {
            await MainActor.run {
                self.hideLoader()
            }
            return
        }
        
        await MainActor.run {
            self.mapRoute = result.locations.map(
                {.init(latitude: $0.lat, longitude: $0.lng)}
            )
            
            MapTabUtils.shared.mapPoints = self.destinations
            
            self.delegate?.onLoadTollCost(viewModel: self, result.toll)
            self.hideLoader()
        }
    }
    
    func onClickSearchAddressFrom() {
        self.removeMarkers()
        self.removeStations()

        searchAddressViewModel.delegate = self
        
        if let loc = self.fromLocation {
            self.editingDestinationId = loc.id
            self.searchAddressViewModel.set(input: loc)
        }
        
        self.presentableRoute = .searchAddress(viewModel: self.searchAddressViewModel)
    }
    
    func onClickSearchAddressTo() {
        self.removeMarkers()
        self.removeStations()
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
        DispatchQueue.main.async {
            self.stations.map({$0.asMarker}).forEach { marker in
                self.stationsMarkers.insert(marker)
            }
        }
    }
    
    func removeStations() {
        self.stations.removeAll()
    }
    
    func removeMarkers() {
        stationsMarkers.forEach { marker in
            marker.map = nil
        }
        stationsMarkers.removeAll()
    }
}
