//
//  MainService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

struct MainService {
    static let shared = MainService()
    
    func findStations(atCity cityId: String) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.stationsInCity(cityId))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(atLocation location: (lat: Double, lng: Double), in distance: Double) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(current: .init(lat: location.lat, lng: location.lng), distance: distance))
        )
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
}
