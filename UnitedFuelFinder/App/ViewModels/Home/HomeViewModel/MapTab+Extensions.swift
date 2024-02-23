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

protocol HomeViewModelProtocol: ObservableObject {
    var isDragging: Bool {get set}
    var state: HomeViewState {get set}
    
    var focusableLocation: CLLocation? {get set}
    
    var fromAddress: String {get set}
    var toAddress: String {get set}
    
    var route: MapTabRouter? {get set}
    
    var presentableRoute: HomePresentableSheets? {get set}
    
    var push: Bool {get set}
    
    var present: Bool {get set}
    
    var pickedLocation: CLLocation? {get set}

    var isLoading: Bool {get set}
    var isDrawing: Bool {get set}
    var isDetectingAddressFrom: Bool {get set}
    var isDetectingAddressTo: Bool {get set}
    
    var loadingMessage: String {get}
        
    var hasDrawen: Bool {get}
    var fromLocation: CLLocation? {get}
    var toLocation: CLLocation? {get set}
    var toLocationCandidate: CLLocation? {get set}
    
    var stations: [StationItem] {get set}
    
    var stationsMarkers: [GMSMarker] {get set}
    
    var distance: String {get}
    
    func startFilterStations()
    func onAppear()
    
    func onClickSelectToPointOnMap()
    func onClickSettings()
    func onClickNotification()
    func onClickViewAllStations()
    func onClickBack()
    func onClickDrawRoute()
    func onClickSearchAddressFrom()
    func onClickSearchAddressTo()
    func onClickFromLocation()
    func onClickToLocation()
    func onStartDrawingRoute()
    func reloadAddress()
    func onEndDrawingRoute(_ isOK: Bool)
    func focusToLocation(_ location: CLLocation)
    func focusToCurrentLocation()
    func clearDestination()
}

extension HomeViewModelProtocol {
    func onClickSelectToPointOnMap() {}
    func onClickSettings() {}
    func onClickNotification() {}
    func onClickViewAllStations() {}
    func onClickBack() {}
    func onClickDrawRoute() {}
    func onClickSearchAddressFrom() {}
    func onClickSearchAddressTo() {}
    func onClickFromLocation() {}
    func onClickToLocation() {}
}

// MARK: - ClickActions
extension MapTabViewModel: HomeViewModelProtocol {
    func onClickSelectToPointOnMap() {
        withAnimation {
            self.state = .selectTo
            if let toLocation {
                focusToLocation(toLocation)
            }
        }
    }
    
    func onClickSettings() {
        self.route = .settings
    }
    
    func onClickNotification() {
        self.route = .notifications
    }
        
    func onClickViewAllStations() {
        self.presentableRoute = .allStations(
            stations: self.stations, from: nil, to: nil, radius: Int(filter?.radius ?? 10),
            location: self.fromLocation?.coordinate, onNavigation: { sta in
                self.focusToLocation(sta.clLocation)
            }, onClickItem: { sta in
                self.route = .stationDetails(station: sta)
            })
    }
    
    func onClickBack() {
        withAnimation {
            self.state = .selectFrom
            self.focusToCurrentLocation()
        }
    }
    
    func onClickDrawRoute() {
        withAnimation {
            self.state = .routing
        }
    }
    
    func onClickSearchAddressFrom() {
        self.presentableRoute = .searchAddress(text: self.fromAddress, { result in
            self.setupFromAddress(with: result)
        })
    }
    
    func onClickSearchAddressTo() {
        self.presentableRoute = .searchAddress(text: self.toAddress, { result in
            self.setupToAddress(with: result)
        })
    }
    
    func onClickFromLocation() {
        guard let fromLocation = fromLocation else {
            return
        }
        focusToLocation(fromLocation)
    }
    
    func onClickToLocation() {
        guard let toLocation else {
            return
        }
        
        focusToLocation(toLocation)
    }
}

// MARK: - Filter methods
extension MapTabViewModel {
    func filterStationsByRoute() {
        DispatchQueue.main.async {
            self.stations = []
            self.stationsList = []
        }
        
        Task {
            guard state == .routing, let toLocation, let fromLocation else {
                return
            }
            let f = (fromLocation.coordinate.latitude, fromLocation.coordinate.longitude)
            let t = (toLocation.coordinate.latitude, toLocation.coordinate.longitude)
            
            let _stations = await MainService.shared.filterStations(
                from: f,
                to: t,
                in: Double(self.filter?.radius ?? 10)
            )
                .sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})
            
            Logging.l(tag: "MapTabViewModel", "Number of new stations \(_stations.count)")
            
            await MainActor.run {
                self.stations = _stations.applyFilter(filter!)
                self.stationsList = _stations
                self.stationsMarkers = self.stations.map({$0.asMarker})
            }
        }
    }
    
    func filterStationsByDefault() {
        Task {
            self.showLoader(message: "loading_stations".localize)
            
            // force to get stations from pinned location
            UserSettings.shared.mapCenterType = .pin
            
            Logging.l(tag: "HomeViewModel", "Start loading stations")
            
            let radius = filter?.radius ?? 10
            
            guard let c = UserSettings.shared.mapCenterType == .currentLocation ? lastCurrentLocation?.coordinate : self.pickedLocation?.coordinate else {
                return
            }
            
            guard let filter else {
                return
            }

            let _stations = await MainService.shared.discountedStations(
                atLocation: (c.latitude, c.longitude),
                in: radius, limit: -1
            )
            
            Logging.l(tag: "HomeViewModel", "Number of stations at \(c) in radius \(radius) is \(stations.count)")
                    
            await MainActor.run {
                self.stationsMarkers.removeAll { mr in
                    mr.map = nil
                    return true
                }
                
                withAnimation {
                    self.stations = _stations.applyFilter(filter)
                    self.stationsList = _stations
                    
                    self.stationsMarkers.append(contentsOf: self.stations.map({$0.asMarker}))
                }
            }
            
            self.hideLoader()
        }
    }
}


public struct Destination: Codable {
    public var latitude: Double
    public var longitude: Double
    
    public var location: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}
