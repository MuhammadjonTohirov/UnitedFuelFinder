//
//  HomeViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import CoreLocation
import USDK
import SwiftUI

enum HomeViewState {
    case selectFrom
    case selectTo
    case routing
}

final class HomeViewModel: ObservableObject {
    @Published var currentLocation: CLLocation?
    
    var fromAddress: String = ""
    var toAddress: String = ""
    
    @Published var pickedLocation: CLLocation?
    @Published var isLoadingAddress: Bool = false
    
    @Published var state: HomeViewState = .selectFrom
    @Published private(set) var isDrawing: Bool = false
    private(set) var hasDrawen: Bool = false
    private(set) var fromLocation: CLLocation?
    private(set) var toLocation: CLLocation?
    private(set) var toLocationCandidate: CLLocation?
    
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
        locationManager.requestLocationPermission()
        locationManager.startUpdatingLocation()
        locationManager.locationUpdateHandler = { [weak self] newLocation in
        
        }
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
        case .selectTo:
            self.toLocation = pickedLocation
        case .routing:
            break
        }
        
        self.isLoadingAddress = true
        
        locationManager.getAddressFromLatLon(latitude: loc.latitude, longitude: loc.longitude) { address in
            DispatchQueue.main.async {
                self.isLoadingAddress = false
                if self.state == .selectFrom {
                    self.fromAddress = address
                } else {
                    self.toAddress = address
                }
            }
        }
    }
    
    func onClickSelectToPointOnMap() {
        withAnimation {
            self.state = .selectTo
            if let toLocation {
                focusToLocation(toLocation)
            }
        }
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
    
    func clearDestination() {
        DispatchQueue.main.async {
            self.hasDrawen = false
            self.toAddress = ""
            self.toLocation = nil
        }
    }
    
    
    func onStartDrawingRoute() {
        DispatchQueue.main.async {
            self.isDrawing = true
        }
    }
    
    func onEndDrawingRoute() {
        DispatchQueue.main.async {
            self.isDrawing = false
            self.hasDrawen = true
        }
    }
}
