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
    
    var asLocation: CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

extension Array where Element == CLLocationCoordinate2D {
    var extremePoints: (left: CLLocationCoordinate2D?, right: CLLocationCoordinate2D?) {
        let points = self
        guard !points.isEmpty else { return (nil, nil) }
        
        var mostLeft = points[0]
        var mostRight = points[0]
        
        for point in points {
            if point.longitude < mostLeft.longitude {
                mostLeft = point
            }
            if point.longitude > mostRight.longitude {
                mostRight = point
            }
        }
        
        return (mostLeft, mostRight)
    }
}
