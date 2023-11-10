//
//  NetReqFilterStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

public struct NetReqFilterStations: Codable {
    public var current: NetReqLocation
    public var distance: Double
    
    public init(current: NetReqLocation, distance: Double) {
        self.current = current
        self.distance = distance
    }
}

public struct NetReqLocation: Codable {
    public var lat: Double
    public var lng: Double
    
    public init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
    }
}


