//
//  MapTabViewModel+Filter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/03/24.
//

import Foundation

fileprivate var defaultFilterStartDate: Date?

extension MapTabViewModel {
    func filterStationsByRoute() {
        DispatchQueue.main.async {
            self.removeStations()
            self.removeMarkers()
            self.showLoader(message: "loading.stations".localize)
        }
        
        guard state == .routing, let toLocation, let fromLocation else {
            return
        }
        
        let radius = Double(self.filter?.radius ?? 10).limitTop(1)
        
        let f: NetReqLocation = .init(lat: fromLocation.coordinate.latitude, lng: fromLocation.coordinate.longitude)
        let t: NetReqLocation = .init(lat: toLocation.coordinate.latitude, lng: toLocation.coordinate.longitude)
        let coordinate = GLocationManager.shared.currentLocation?.coordinate
        let c: NetReqLocation = .init(lat: coordinate?.latitude ?? 0, lng: coordinate?.longitude ?? 0)
        
        @Sendable func onLoadStations(_ _stations: [StationItem]) async {
            await MainActor.run {
                self.stations = _stations.applyFilter(self.filter!)
                self.stationsMarkers = Set(self.stations.map({$0.asMarker}))
                self.hideLoader()
            }
        }
        
        Task {
            guard state == .routing else {
                return
            }
            
            await URLSession.filter.cancelAllTasks()
            
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
            _request.current = c
            
            let _stations = await MainService.shared.filterStations2(req: _request)
                .0
                .sorted(by: {$0.distanceFromCurrentLocation < $1.distanceFromCurrentLocation})

            Logging.l(tag: "MapTabViewModel", "Number of new stations \(_stations.count)")
            await onLoadStations(_stations)
        }
    }
    
    func filterStationsByDefault() {
        guard let filter, let pickedLocation, state == .selectFrom else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            self.interactor.filterStationsByDefaultFromDatabase(filter, location: pickedLocation) { [weak self] stations in
                guard let self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.removeMarkers()
                    self.stations = stations
                    self.setupMarkers()
                }
            }
        }
    }
    
    func onDraggingMap() {
        // TODO: Handle dragging change
    } 
}
