//
//  MapTabViewModel+SearchAddress.swift
//  UnitedFuelFinder
//
//  Created by applebro on 04/06/24.
//

import Foundation
import SwiftUI

extension MapTabViewModel: SearchAddressProtocol {
    func reloadAddress() {
        if state == .routing {
            return
        }
        
        guard let loc = pickedLocation?.coordinate else {
            return
        }
        
        self.isDetectingAddressFrom = true
        
        Task {
            let address = await GLocationManager.shared.asyncAddress(
                latitude: loc.latitude,
                longitude: loc.longitude
            )
            
            if state == .default {
                self.editingDestinationId = destinations.first?.id
            }
            
            if state == .pickLocation && destinations.count == 1 {
                self.editingDestinationId = nil
            }
                        
            await MainActor.run {
                self.isDetectingAddressFrom = false
                self.pickedLocationAddress = address
                
                if let editingDestination = self.destinations.first(where: {$0.id == self.editingDestinationId}) {
                    editingDestination.location = loc
                    editingDestination.address = address
                } else {
                    if state == .pickLocation {
                        return
                    }
                    addDestination(.init(location: loc, address: address))
                }
            }
        }
    }
    
    func searchAddress(
        viewModel: SearchAddressViewModel,
        result: SearchAddressViewModel.SearchAddressResult
    ) {
        self.currentDestination = .init(
            location: .init(latitude: result.lat, longitude: result.lng),
            address: result.address
        )
        
        addDestination(currentDestination!)
        self.searchAddressViewModel.dispose()
        self.presentableRoute = nil
    }
    
    func searchAddress(
        viewModel: SearchAddressViewModel,
        edit: SearchAddressViewModel.SearchAddressResult?
    ) {
        self.editingDestinationId = edit?.id
        self.state = .pickLocation
        self.presentableRoute = nil
    }
    
    func onClickDonePickAddress() {
        withAnimation {
            if editingDestinationId == nil, let location = self.pickedLocation, let address = self.pickedLocationAddress {
                self.addDestination(.init(location: location.coordinate, address: address))
            }
            
            if state == .default {
                self.startFilterStations()
            }
            
            if let destination = self.destinations.first(
                where: {$0.id == editingDestinationId}
            ), let coordinate = pickedLocation?.coordinate {
                destination.location = coordinate
                let _destinations = self.destinations

                self.removeMarkers()
                self.removeStations()
                self.removeDestinations()
                self.mapRoute.removeAll()
                self.state = .routing

                self.destinations = _destinations
                
                Task {
                    await self.drawRoute()
                    self.startFilterStations()
                }
            }
        }
    }
    
    func onClickAllDestinations() {
        destinationsViewModel.destinations = destinations
        destinationsViewModel.delegate = self
        self.route = .destinations(viewModel: destinationsViewModel)
    }
    
    func onClickAddDestination() {
        self.searchAddressViewModel.dispose()
        self.searchAddressViewModel.delegate = self
        self.presentableRoute = .searchAddress(viewModel: searchAddressViewModel)
    }
    
    func addDestination(_ destination: MapDestination) {
        Logging.l(tag: "Destination", "Insert \(destination.id) | \(destination.location)")
        guard state != .routing else {
            return
        }
        
        self.destinations.append(destination)
        
        if destinations.count >= 2 {
            Task {
                await MainActor.run {
                    self.state = .routing
                }
                
                await self.drawRoute()
                self.startFilterStations()
            }
        }
    }
}

extension MapTabViewModel: DestinationsDelegate {
    func commitChanges(model: DestinationsViewModel, destinations: [MapDestination]) {
        self.route = nil
        self.presentableRoute = nil
        self.removeMarkers()
        self.removeStations()
        self.removeDestinations()
        
        self.destinations = destinations
        
        Task {
            await drawRoute()
            
            await MainActor.run {
                self.startFilterStations()
            }
        }
    }
    
    func editDestination(model: DestinationsViewModel, destination: MapDestination) {
        self.searchAddressViewModel.dispose()
        self.searchAddressViewModel.set(input: destination)
        self.searchAddressViewModel.delegate = self
        self.route = nil
        self.presentableRoute = nil
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.presentableRoute = .searchAddress(viewModel: self.searchAddressViewModel)
        }
    }
}
