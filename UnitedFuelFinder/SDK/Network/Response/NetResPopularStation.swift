//
//  NetResPopularStation.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct NetResPopularStationItem: NetResBody {
    let customer: String
    let station: String
    let value: Int
}

public struct NetResPopularStations: NetResBody {
    var total: Int
    var rows: [NetResPopularStationItem]
}
