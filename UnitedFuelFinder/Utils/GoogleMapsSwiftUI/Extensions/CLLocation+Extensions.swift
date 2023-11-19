//
//  CLLocation+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/10/23.
//

import Foundation
import MapKit
import GoogleMaps

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    
    var toMapPoint: MKMapPoint {
        return MKMapPoint(self)
    }
    
    func toScreenPoint(on map: GMSMapView) -> CGPoint {
        map.projection.point(for: self)
    }
}
