//
//  NetReqFilterStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

public struct NetReqFilterStations: Codable {
    public var from: NetReqLocation?
    public var to: NetReqLocation?
    public var current: NetReqLocation?
    public var distance: Int?
    
    public init(from: NetReqLocation?, to: NetReqLocation?, current: NetReqLocation?, distance: Int?) {
        self.from = from
        self.to = to
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


