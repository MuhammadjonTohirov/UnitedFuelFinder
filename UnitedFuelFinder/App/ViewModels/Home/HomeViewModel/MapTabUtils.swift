//
//  MapTabUtils.swift
//  UnitedFuelFinder
//
//  Created by applebro on 14/06/24.
//

import Foundation

struct MapTabUtils {
    static var shared = MapTabUtils()
    
    @codableWrapper(key: "routePoints", nil)
    public var mapPoints: [MapDestination]?
}
