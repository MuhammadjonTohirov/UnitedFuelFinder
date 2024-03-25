//
//  MapTabInteractor.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/03/24.
//

import Foundation
import CoreLocation

protocol SearchRouteProtocol {
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void)
}

protocol MapTabInteractorProtocol {
    init(routeSearcher: any SearchRouteProtocol)
    
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void)
    
    func filterStationsByDefault(_ filter: MapFilterInput, location: CLLocation) async -> [StationItem]
    
    func filterStationsByDefaultFromDatabase(_ filter: MapFilterInput, location: CLLocation, completion: @escaping ([StationItem]) -> Void)
}

struct GoogleRouteSearcher: SearchRouteProtocol {
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        GoogleNetwork.getRoute(
            from: from,
            to: to) { route in
                completion(route)
            }
    }
}

struct ServerRouteSearcher: SearchRouteProtocol {
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        Task {
            let result: NetRes<[NetResRouteItem]>? = await Network.send(
                request: CommonNetworkRouter.findRoute(
                req: .init(
                    from: .init(lat: from.latitude, lng: from.longitude),
                    to: .init(lat: to.latitude, lng: to.longitude)
                    )
                )
            )
            
            completion(result?.data?.compactMap({CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng)}) ?? [])
        }
    }
}

class MapTabInteractor: MapTabInteractorProtocol {
    var routeSearcher: any SearchRouteProtocol
    private var isFiltering: Bool = false
    
    required init(routeSearcher: any SearchRouteProtocol) {
        self.routeSearcher = routeSearcher
    }
    
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        routeSearcher.searchRoute(from: from, to: to, completion: completion)
    }
    
    func filterStationsByDefault(_ filter: MapFilterInput, location: CLLocation) async -> [StationItem] {
        let maxRadius = filter.radius
        
        var _request: NetReqFilterStations = .init(
            distance: Double(maxRadius),
            stations: Array(filter.selectedStations)
        )
        
        _request.current = .init(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
        let (_stations, _) = await MainService.shared.filterStations2(req: _request)
        
        return _stations
    }
    
    func filterStationsByDefaultFromDatabase(_ filter: MapFilterInput, location: CLLocation, completion: @escaping ([StationItem]) -> Void) {
        if isFiltering {
            return
        }
        
        debugPrint("Filter stations in \(filter.radius) at \(location)")
        DispatchQueue.global(qos: .background).async {
            self.isFiltering = true
            var filteredStations = DStationItem.all?.filter
            { station in
                let distance = location.distance(from: CLLocation(latitude: station.lat, longitude: station.lng)).f.asMile
                return Int(distance) < filter.radius && filter.selectedStations.contains(station.customerId)
            }
            .filter { station in
                if let stateId = filter.stateId?.nilIfEmpty {
                    return station.stateId == stateId
                }
                
                if let cityId = filter.cityId {
                    return station.cityId == cityId
                }
                
                return true
            }
            .filter { station in
                let retailPrice = station.retailPrice ?? 0
                let discount = station.discountPrice ?? 0
                let actualPrice = retailPrice - discount

                return actualPrice > filter.from && actualPrice < filter.to
            }
//            .filter { station in
//                filter.selectedStations.contains(station.id)
//            }
            .map({$0.asModel}) ?? []
            
            for i in 0..<filteredStations.count {
                let item = filteredStations[i]
                item.distance = Float(location.distance(from: CLLocation(latitude: item.lat, longitude: item.lng)).f.asMile)
                filteredStations[i].distance = item.distance
            }
            
            filteredStations = filteredStations.sorted(by: { st1, st2 in
                switch filter.sortType {
                case .distance:
                    return (st1.distance ?? 0) < (st2.distance ?? 0)
                case .price:
                    return st1.actualPrice < st2.actualPrice
                case .discount:
                    return (st1.retailPrice ?? 0) < (st2.retailPrice ?? 0)
                }
            })
            
            debugPrint(filteredStations.compactMap({$0.distance}))
            
            completion(filteredStations)
            self.isFiltering = false
        }
    }
}
