//
//  NetReqFilterStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

//{
//  "from": {
//    "lat": 0,
//    "lng": 0
//  },
//  "to": {
//    "lat": 0,
//    "lng": 0
//  },
//  "distance": 1,
//  "sortBy": "string",
//  "fromPrice": 0,
//  "toPrice": 0,
//  "stations": [
//    0
//  ],
//  "stateId": "string",
//  "cityId": 0
//}

public enum NetReqFilterSortType: String, Codable {
    case price
    case discount
}

public struct NetReqFilterStations: Codable {
    public var current: NetReqLocation?
    public var from: NetReqLocation?
    public var to: NetReqLocation?
    public var distance: Double
    public var sortedBy: NetReqFilterSortType?
    public var fromPrice: Int = 0
    public var toPrice: Int = 1000
    public var stations: [Int] = []
    public var stateId: String?
    public var cityId: Int?
    
    
    public init(current: NetReqLocation, distance: Double) {
        self.current = current
        self.distance = distance
    }
    
    public init(from: NetReqLocation, to: NetReqLocation, distance: Double) {
        self.from = from
        self.to = to
        self.distance = distance
    }
    
    init(
        current: NetReqLocation,
        distance: Double,
        sortedBy: NetReqFilterSortType?,
        fromPrice: Int = 0,
        toPrice: Int = 1000,
        stations: [Int] = [],
        stateId: String? = nil,
        cityId: Int? = nil)
    {
        self.current = current
        self.distance = distance
        self.sortedBy = sortedBy
        self.fromPrice = fromPrice
        self.toPrice = toPrice
        self.stations = stations
        self.stateId = stateId
        self.cityId = cityId
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
