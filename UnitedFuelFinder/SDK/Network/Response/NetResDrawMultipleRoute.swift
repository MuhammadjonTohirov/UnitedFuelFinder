//
//  NetResDrawMultipleRoute.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/06/24.
//

import Foundation

struct NetResDrawMultipleRoute: NetResBody {
    var locations: [NetResDrawMultipleRoute.Location]
    var toll: Float
    
    struct Location: Codable {
        var lat: Double
        var lng: Double
        var isEmpty: Bool
    }
}
