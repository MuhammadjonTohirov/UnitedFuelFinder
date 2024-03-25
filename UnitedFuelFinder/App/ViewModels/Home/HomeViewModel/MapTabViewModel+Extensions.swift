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
    var filterUrlSession: URLSession {get}
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
    
    var stationsMarkers: Set<GMSMarker> {get set}
    
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
    var filterUrlSession: URLSession {
        .filter
    }
    
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
        self.removeMarkers()
        self.removeStations()
        withAnimation {
            self.state = .selectTo
            if let toLocation {
                focusToLocation(toLocation)
            }
        }
        
        removeMarkers()
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
            self.filterStationsByDefault()
        }
    }
    
    func onClickDrawRoute() {
        self.mapRoute = []
        
        if let _from = self.fromLocation, let _to = self.toLocation {
            UserSettings.shared.fromLocation = .init(latitude: _from.coordinate.latitude, longitude: _from.coordinate.longitude)
            self.showLoader(message: "searching.route".localize)
            interactor.searchRoute(
                from: _from.coordinate,
                to: _to.coordinate) { route in
                    DispatchQueue.main.async {
                        self.hideLoader()
                        self.mapRoute = route
                        
                        if route.isEmpty {
                            self.state = .selectFrom
                            self.filterStationsByDefault()
                            UserSettings.shared.fromLocation = nil
                            UserSettings.shared.destination = nil
                        } else {
                            self.state = .routing
                            self.filterStationsByRoute()
                        }
                    }
                }
            return
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
    
    func setupMarkers() {
        DispatchQueue.main.async {
            self.stations.map({$0.asMarker}).forEach { marker in
                self.stationsMarkers.insert(marker)
            }
        }
    }
    
    func removeStations() {
        self.stations = []
    }
    
    func removeMarkers() {
        stationsMarkers.forEach { marker in
            marker.map = nil
        }
        stationsMarkers.removeAll()
//        self.stationsMarkers.forEach { mr in
//            if let pl = self.pickedLocation?.coordinate {
//                let distance = pl.distance(to: mr.position).f.asMile
//                // remove not in distance
//                if distance > CGFloat(self.filter?.radius ?? 10) {
//                    mr.map = nil
//                    self.stationsMarkers.remove(mr)
//                }
//            }
//        }
//        self.stationsMarkers.removeAll { mr in
//            // remove mr not in radius
//            if let pl = self.pickedLocation?.coordinate {
//                let distance = pl.distance(to: mr.position).f.asMile
//                // remove not in distance
//                if distance > CGFloat(self.filter?.radius ?? 10) {
//                    mr.map = nil
//                    return true
//                }
//            }
//            
//            return false
//        }
    }
}


public struct Destination: Codable {
    public var latitude: Double
    public var longitude: Double
    
    public var location: CLLocation {
        .init(latitude: latitude, longitude: longitude)
    }
}
