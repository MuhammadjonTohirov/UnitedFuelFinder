// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

//
//  MapViewControllerBridge.swift
//  GoogleMapsSwiftUI
//
//  Created by Chris Arriola on 2/5/21.
//

import GoogleMaps
import GoogleMapsUtils
import GoogleMapsCore
import SwiftUI

import CoreLocation

struct GMapsViewWrapper: UIViewControllerRepresentable {
    var location: CLLocation?
    @Binding var pickedLocation: CLLocation?
    @Binding var isDragging: Bool
    @State var camera: GMSCameraPosition?
    var screenCenter: CGPoint
    @Binding var markers: Set<GMSMarker>

    var onClickMarker: ((_ marker: GMSMarker, _ frame: CGPoint) -> Void)?
    var route: [CLLocationCoordinate2D] = []
    var didRadiusChanged: Bool = true

    var radius: CLLocationDistance = .zero
    
    var onChangeVisibleArea: ((_ radius: CGFloat) -> Void)?
    
    init(pickedLocation: Binding<CLLocation?>, isDragging: Binding<Bool>, screenCenter: CGPoint, markers: Binding<Set<GMSMarker>>) {
        self._isDragging = isDragging
        self._pickedLocation = pickedLocation
        self.screenCenter = screenCenter
        self._markers = markers
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func set(radius: CLLocationDistance) -> Self {
        var v = self
        v.radius = radius
        return v
    }
    
    func set(onClickMarker: @escaping (_ marker: GMSMarker, _ frame: CGPoint) -> Void) -> Self {
        var v = self
        v.onClickMarker = onClickMarker
        return v
    }
    
    func set(onChangeVisibleArea: @escaping (_ radius: CGFloat) -> Void) -> Self {
        var v = self
        v.onChangeVisibleArea = onChangeVisibleArea
        return v
    }
    
    func set(currentLocation: CLLocation?) -> Self {
        var v = self
        v.location = currentLocation
        return v
    }
    
    func set(route: [CLLocationCoordinate2D]) -> Self {
        var v = self
        
        if v.route.first != route.first && v.route.last != route.last {
            v.route = route
        }
        
        return v
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let mapController = MapViewController()
        mapController.delegate = context.coordinator
        
        let hasSafeArea = UIApplication.shared.safeArea.bottom != .zero
        
        let bottom = 115 - UIApplication.shared.safeArea.bottom + (hasSafeArea ? UIApplication.shared.safeArea.bottom : 20)
        
        mapController.set(
            padding: .init(
                top: 0, 
                left: 0,
                bottom: bottom, 
                right: 0
            )
        )
        
        return mapController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
        if let location {
            let position = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 8)
            uiViewController.map.animate(to: position)
        }
        
//       MARK: markers drawing
//        if context.coordinator.clusterManager == nil {
//            context.coordinator.setupCluster(
//                mapView: uiViewController.map,
//                withMarkers: self.markers
//            )
//        } else {
//            context.coordinator.updateCluster(withMarkers: self.markers)
//        }
        
        context.coordinator.setupMarkers(onMap: uiViewController.map, withMarkers: self.markers)
        
        if !self.route.isEmpty {
            context.coordinator.setMapMarkersRoute(route: route, on: uiViewController.map)
        } else {
            context.coordinator.clearRoute(onMap: uiViewController.map)
            context.coordinator.endDrawing()
        }
        
//       MARK: Radius change
        if didRadiusChanged, let coordinate = self.pickedLocation?.coordinate {
            if radius > 0 {
                context.coordinator.drawCircleByRadius(
                    on: uiViewController.map,
                    location: coordinate, 
                    radius: radius
                )
            } else {
                context.coordinator.removeCircle()
            }
        }
    }
}


extension CLLocationCoordinate2D {
//    coordinateWithBearing
    func coordinateWithBearing(bearing:Double, distanceMeters:Double) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let lat1 = self.latitude * Double.pi / 180
        let lon1 = self.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))

        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}

extension GMSVisibleRegion {
    func contains(_ coordinate: CLLocationCoordinate2D) -> Bool {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude
        let topLat = self.farLeft.latitude
        let bottomLat = self.nearRight.latitude
        let leftLng = self.farLeft.longitude
        let rightLng = self.nearRight.longitude
        return (topLat >= latitude &&
            bottomLat <= latitude &&
            leftLng <= longitude &&
            rightLng >= longitude)
    }
}
