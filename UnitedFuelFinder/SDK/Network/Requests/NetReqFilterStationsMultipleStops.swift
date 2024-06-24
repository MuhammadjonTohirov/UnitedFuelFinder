//
//  NetReqFilterStationsMultipleStops.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/06/24.
//

import Foundation

public struct NetReqFilterStationsMultipleStops: Codable {
    public var current: NetReqLocation = .init()
    public var stops: [NetReqLocation] = []
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
    
    public init(stops: [NetReqLocation], distance: Double) {
        self.stops = stops
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
        case stops
        case distance
        case sortedBy
        case fromPrice
        case toPrice
        case stations
        case stateId
        case cityId
    }
}
