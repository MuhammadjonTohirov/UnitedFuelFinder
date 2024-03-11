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
        
        Task(priority: .utility) {
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
            
            await MainActor.run {
                self.stations = _stations.applySort(self.filter!)
                self.stationsMarkers = self.stations.map({$0.asMarker})
                self.hideLoader()
            }
        }
    }
    
    func filterStationsByDefault() {
        func _startFilter() {
            Task(priority: .medium) {
                guard state == .selectFrom, !isFilteringStations else {
                    return
                }
                
                // force to get stations from pinned location
                UserSettings.shared.mapCenterType = .pin
                
                // cancel all active tasks
                await URLSession.filter.cancelAllTasks()
                
                Logging.l(tag: "HomeViewModel", "Start loading stations")
                
                let maxRadius = self.filter?.radius ?? 300
                let minRadius = Int(Double(maxRadius) * 0.4).limitBottom(1)

                let radius = (Int(screenVisibleArea).limitTop(maxRadius).asDouble * 0.6).asInt.limitBottom(minRadius)
                
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
                
                await MainActor.run {
                    self.isFilteringStations = true
                }
                
                let (_stations, error) = await MainService.shared.filterStations2(req: _request)
                
                Logging.l(tag: "HomeViewModel", "Finish loading stations, has error \(error != nil)")

                await MainActor.run {
                    self.isFilteringStations = false
                }
                
                if error != nil || state != .selectFrom {
                    return
                }
                
                Logging.l(tag: "HomeViewModel", "Number of stations at \(c) in radius \(radius) is \(_stations.count)")
                        
                await MainActor.run {
                    self.removeMarkers()
                    self.removeStations()

                    self.stations = _stations.applySort(self.filter!)
                    
                    if !self.didDisappear {
                        self.setupMarkers()
                    }
                    
                    self.hideLoader()
                }
            }
        }
        
        _startFilter()
    }
    
    func onDraggingMap() {
        // TODO: Handle dragging change
        
        if screenVisibleArea > 200 {
            if self.state == .selectFrom {
                Task {
                    await URLSession.filter.cancelAllTasks()
                    
                    DispatchQueue.main.async {
                        self.removeMarkers()
                        self.removeStations()
                    }
                }
            }
        }
    }
}
