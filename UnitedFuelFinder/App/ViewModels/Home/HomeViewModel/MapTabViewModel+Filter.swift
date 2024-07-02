//
//  MapTabViewModel+Filter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/03/24.
//

import Foundation
import RealmSwift

extension MapTabViewModel {
    func setupMarkersByStations(_ _stations: [StationItem]) {
        self.stations = _stations.applyFilter(self.filter!)
        self.stationsMarkers = Set(self.stations.map({$0.asMarker}))
    }
    
    func tryResetMarkers() -> Bool {
        if self.stationsMarkers.isEmpty && !self.stations.isEmpty {
            self.setupMarkers()
            return true
        }
        
        return false
    }
    
    func filterStationsByRoute() {
        mainIfNeeded {
            self.removeStations()
            self.removeMarkers()
            self.showLoader(message: "loading.stations".localize)
        }
        
        guard state == .routing else {
            return
        }
        
        @Sendable func onLoadStations(_ _stations: [StationItem]) async {
            await MainActor.run {
                self.setupMarkersByStations(_stations)
                self.hideLoader()
            }
        }
        
        filterTask?.cancel()
        
        filterTask = Task.detached(priority: .high) { [weak self] in
            guard let self else {
                return
            }
            
            guard state == .routing else {
                return
            }
            
            await URLSession.filter.cancelAllTasks()
            
            let _request: NetReqFilterStationsMultipleStops = routeRequest
            
            if filterTask?.isCancelled ?? true {
                return
            }
            
            let _stations = await MainService.shared.filterStations3(req: _request)
                .0
                .sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})

            _stations.forEach { station in
                station.customer = DCustomer.all?.filter("id = %d", station.customerId).first?.asModel
                station.state = Realm.new?.object(ofType: DState.self, forPrimaryKey: station.stateId)?.asModel
                station.city = Realm.new?.object(ofType: DCity.self, forPrimaryKey: station.cityId)?.asModel
            }
            
            Logging.l(tag: "MapTabViewModel", "Number of new stations \(_stations.count) from server")
            await onLoadStations(_stations)
        }
    }
    
    private var routeRequest: NetReqFilterStationsMultipleStops {
        let radius = Double(self.filter?.radius ?? 10).limitTop(1)
        var _request: NetReqFilterStationsMultipleStops = .init(
            distance: radius,
            sortedBy: .init(rawValue: filter?.sortType.rawValue ?? ""),
            fromPrice: filter?.from ?? 0,
            toPrice: filter?.to ?? 1000,
            stations: Array(filter?.selectedStations ?? []),
            stateId: filter?.stateId ?? "",
            cityId: filter?.cityId ?? 0
        )
        
        let coordinate = GLocationManager.shared.currentLocation?.coordinate
        let c: NetReqLocation = .init(
            lat: coordinate?.latitude ?? 0,
            lng: coordinate?.longitude ?? 0
        )
        
        _request.stops = self.destinations.map({
            .init(
                lat: $0.location.latitude,
                lng: $0.location.longitude
            )
        })
        _request.current = c
        
        return _request
    }
    
    func filterStationsByDefault() {
        guard let filter, let pickedLocation, state == .default else {
            return
        }
        
        self.interactor.filterStationsByDefaultFromDatabase(filter, location: pickedLocation) { [weak self] stations in
            guard let self else {
                return
            }
            
            Logging.l(tag: "MapTabViewModel", "Number of new stations \(stations.count) from db")
            
            DispatchQueue.main.async {
                self.removeMarkers()
                self.stations = stations
                self.setupMarkers()
            }
        }
    }
    
    func onDraggingMap() {
        // TODO: Handle dragging change
    }
}
