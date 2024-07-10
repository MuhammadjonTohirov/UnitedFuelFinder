//
//  MainService+Stations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainService {
    @Sendable func syncAllStations() async {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.allStations)
        
        result?.data?.forEach { item in
            debugPrint(item.asString)
        }
        
        let stations: [DStationItem] = result?.data?.map { resStation in
            return DStationItem.create(resStation)
        } ?? []
        
//        try? await Task.sleep(for: .milliseconds(100))
//        DStationItem.deleteAll()
        await StationDService.shared.deleteAll()
//        try? await Task.sleep(for: .milliseconds(100))
        await StationDService.shared.addStations(stations)
//        DStationItem.insertAll(stations)
    }
}
