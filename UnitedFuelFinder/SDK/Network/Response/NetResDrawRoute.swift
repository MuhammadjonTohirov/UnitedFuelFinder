//
//  NetResDrawRoute.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/03/24.
//

import Foundation

public struct NetReqDrawRoute: Codable {
    public let from: NetReqLocation
    public let to: NetReqLocation
}

public struct NetResRouteItem: Codable {
    public var lat: Double
    public var lng: Double
}
