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
    
    func filterStationsByDefault(_ filter: MapFilterInput) async -> [StationItem]
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
    
    private var filterRequestDate: Date?
    
    required init(routeSearcher: any SearchRouteProtocol) {
        self.routeSearcher = routeSearcher
    }
    
    func searchRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([CLLocationCoordinate2D]) -> Void) {
        routeSearcher.searchRoute(from: from, to: to, completion: completion)
    }
    
    func filterStationsByDefault(_ filter: MapFilterInput) async -> [StationItem] {
        filterRequestDate = Date()
        
        return []
    }
}
