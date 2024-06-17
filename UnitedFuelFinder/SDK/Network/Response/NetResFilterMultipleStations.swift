//
//  NetResFilterMultipleStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/06/24.
//

import Foundation

struct NetResFilterMultipleStations: NetResBody {
    var stations: [NetResStationItem]
    var toll: Float
}
