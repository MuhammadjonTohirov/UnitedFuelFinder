//
//  PopularStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct PopularStationItem: NetResBody {
    let customer: String
    let station: String
    let value: Int
}

public struct PopularStations: NetResBody {
    var total: Int
    var rows: [PopularStationItem]
}

