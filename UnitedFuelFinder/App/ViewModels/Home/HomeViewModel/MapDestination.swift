//
//  MapDestination.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/06/24.
//

import Foundation
import CoreLocation

public class MapDestination: Identifiable, Codable {
    public var id: String
    
    var location: CLLocationCoordinate2D
    var address: String?
    
    init(
        id: String = UUID().uuidString,
        location: CLLocationCoordinate2D,
        address: String? = nil
    ) {
        self.id = id
        self.location = location
        self.address = address
    }
}
