//
//  MultipleRouteModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/06/24.
//

import Foundation

struct MultipleRouteModel {
    var locations: [MultipleRouteModel.Location]
    var toll: Float
    
    struct Location: Codable {
        var lat: Double
        var lng: Double
        var isEmpty: Bool
        
        init(res: NetResDrawMultipleRoute.Location) {
            self.lat = res.lat
            self.lng = res.lng
            self.isEmpty = res.isEmpty
        }
    }
    
    init(locations: [MultipleRouteModel.Location], toll: Float) {
        self.locations = locations
        self.toll = toll
    }
    
    init(res: NetResDrawMultipleRoute) {
        self.locations = res.locations.map({.init(res: $0)})
        self.toll = res.toll
    }
}
