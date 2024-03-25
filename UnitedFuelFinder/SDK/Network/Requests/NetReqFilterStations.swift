//
//  NetReqFilterStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

public enum NetReqFilterSortType: String, Codable {
    case price
    case discount
    case distance
}

public struct NetReqFilterStations: Codable {
    public var current: NetReqLocation = .init()
    public var from: NetReqLocation = .init()
    public var to: NetReqLocation = .init()
    public var distance: Double = 300
    public var sortedBy: String = ""
    public var fromPrice: Float = 0
    public var toPrice: Float = 0
    public var stations: [Int] = []
    public var stateId: String = ""
    public var cityId: Int = 0
    
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
        current: NetReqLocation = .init(),
        distance: Double = 300,
        sortedBy: NetReqFilterSortType? = nil,
        fromPrice: Float = 0,
        toPrice: Float = 0,
        stations: [Int] = [],
        stateId: String = "",
        cityId: Int = 0)
    {
        self.current = current
        self.distance = distance
        self.sortedBy = sortedBy?.rawValue ?? ""
        self.fromPrice = fromPrice
        self.toPrice = toPrice
        self.stations = stations
        self.stateId = stateId
        self.cityId = cityId
    }
    
    enum CodingKeys: CodingKey {
        case current
        case from
        case to
        case distance
        case sortedBy
        case fromPrice
        case toPrice
        case stations
        case stateId
        case cityId
    }
}

public struct NetReqLocation: Codable {
    public var lat: Double
    public var lng: Double
    
    public init(lat: Double = 0, lng: Double = 0) {
        self.lat = lat
        self.lng = lng
    }
}
