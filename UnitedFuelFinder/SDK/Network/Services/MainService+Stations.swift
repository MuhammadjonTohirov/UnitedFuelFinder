//
//  MainService+Stations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainService {
    func syncAllStations() async {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.allStations)
        
        result?.data?.forEach { item in
            debugPrint(item.asString)
        }
        
        let stations: [DStationItem] = result?.data?.map { resStation in
            return DStationItem.create(resStation)
        } ?? []
        
        DStationItem.deleteAll()
        DStationItem.insertAll(stations)
    }
}
