//
//  MainService+Filter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainService {
    func findStations(atCity cityId: String) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.stationsInCity(cityId))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(atLocation location: (lat: Double, lng: Double), in distance: Int) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(
                current: .init(
                    lat: location.lat,
                    lng: location.lng
                ),
                distance: Double(distance)
            )
        ))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(from location: (lat: Double, lng: Double), to toLocation: (lat: Double, lng: Double), in distance: Double = 300) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(
                from: .init(lat: location.lat, lng: location.lng),
                to: .init(lat: toLocation.lat, lng: toLocation.lng),
                distance: distance
            ))
        )
        
        let items: [StationItem] = ((result?.data) ?? []).compactMap({.init(res: $0)})
        return items
    }
    
    func filterStations(req: NetReqFilterStations) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(request: req))
        
        let items: [StationItem] = ((result?.data) ?? []).compactMap({.init(res: $0)})
        return items
    }

    func filterStations2(req: NetReqFilterStations, session: URLSession = URLSession.filter) async -> ([StationItem], Error?) {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations2(request: req), session: session)
        let hasData = result?.data != nil
        let list: [StationItem] = ((result?.data) ?? []).compactMap({.init(res: $0)})
        return (list, hasData ? nil : NSError(domain: "No stations", code: -1))
    }
    
    func filterStations3(
        req: NetReqFilterStationsMultipleStops,
        session: URLSession = URLSession.filter
    ) async -> ([StationItem], Error?) {
        let result: NetRes<NetResFilterMultipleStations>? = await Network.send(
            request: MainNetworkRouter.filterStations3(request: req),
            session: session
        )

        let hasData = result?.data != nil
        let list: [StationItem] = ((result?.data?.stations) ?? []).compactMap({.init(res: $0)})
        return (list, hasData ? nil : NSError(domain: "No stations", code: -1))
    }
}
