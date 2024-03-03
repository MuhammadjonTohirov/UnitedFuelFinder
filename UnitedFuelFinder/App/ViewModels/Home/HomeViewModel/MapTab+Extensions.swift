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
        if let _from = self.fromLocation, let _to = self.toLocation {
            self.showLoader(message: "searching.route".localize)
            GoogleNetwork.getRoute(
                from: _from.coordinate,
                to: _to.coordinate) { route in
                    DispatchQueue.main.async {
                        self.mapRoute = route
                        
                        self.hideLoader()
                        
                        withAnimation {
                            self.state = .routing
                        }
                        
                        self.filterStationsByRoute()
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
    func filterStationsByRoute() {
        DispatchQueue.main.async {
            self.stations = []
            self.showLoader(message: "loading.stations".localize)
        }
        
        guard state == .routing, let toLocation, let fromLocation else {
            return
        }
        
        let radius = Double(self.filter?.radius ?? 10).limitTop(1)
        
        let f: NetReqLocation = .init(lat: fromLocation.coordinate.latitude, lng: fromLocation.coordinate.longitude)
        let t: NetReqLocation = .init(lat: toLocation.coordinate.latitude, lng: toLocation.coordinate.longitude)
        
        Task {
            guard state == .routing else {
                return
            }
            
            var _request: NetReqFilterStations = .init(
                distance: radius,
                sortedBy: .init(rawValue: filter?.sortType.rawValue ?? ""),
                fromPrice: filter?.from ?? 0,
                toPrice: filter?.to ?? 1000,
                stations: Array(filter?.selectedStations ?? []),
                stateId: filter?.stateId ?? "",
                cityId: filter?.cityId ?? 0
            )
            
            _request.from = f
            _request.to = t
            
            let _stations = await MainService.shared.filterStations2(req: _request)
                .sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})
            
            Logging.l(tag: "MapTabViewModel", "Number of new stations \(_stations.count)")
            
            await MainActor.run {
                self.stations = _stations
                self.stationsMarkers = self.stations.map({$0.asMarker})
                self.hideLoader()
            }
        }
    }
    
    func filterStationsByDefault() {
        Task {
            
            // force to get stations from pinned location
            UserSettings.shared.mapCenterType = .pin
            
            Logging.l(tag: "HomeViewModel", "Start loading stations")
            
            let radius = filter?.radius ?? 10
            
            guard let c = UserSettings.shared.mapCenterType == .currentLocation ? lastCurrentLocation?.coordinate : self.pickedLocation?.coordinate else {
                return
            }
            
            var _request: NetReqFilterStations = .init(
                distance: Double(radius),
                stations: Array(filter?.selectedStations ?? [])
            )
            
            _request.current = .init(
                lat: c.latitude,
                lng: c.longitude
            )
            
            let _stations = await MainService.shared.filterStations2(req: _request)
            
            Logging.l(tag: "HomeViewModel", "Number of stations at \(c) in radius \(radius) is \(stations.count)")
                    
            await MainActor.run {
                self.stationsMarkers.removeAll { mr in
                    mr.map = nil
                    return true
                }
                
                withAnimation {
                    self.stations = _stations
                    
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
