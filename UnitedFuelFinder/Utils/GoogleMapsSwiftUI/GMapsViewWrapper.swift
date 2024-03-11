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
    private(set) var location: CLLocation?
    @Binding var pickedLocation: CLLocation?
    @Binding var isDragging: Bool
    @State var camera: GMSCameraPosition?
    var screenCenter: CGPoint
    @Binding var markers: [GMSMarker]

    fileprivate var onClickMarker: ((_ marker: GMSMarker, _ frame: CGPoint) -> Void)?
    fileprivate var route: [CLLocationCoordinate2D] = []
    fileprivate var didRadiusChanged: Bool = true

    fileprivate var radius: CLLocationDistance = .zero
    
    fileprivate var onChangeVisibleArea: ((_ radius: CGFloat) -> Void)?
    
    init(pickedLocation: Binding<CLLocation?>, isDragging: Binding<Bool>, screenCenter: CGPoint, markers: Binding<[GMSMarker]>) {
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
            let position = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 5.3)
            uiViewController.map.animate(to: position)
        }
        
//       MARK: markers drawing
        if context.coordinator.clusterManager == nil {
            context.coordinator.setupCluster(
                mapView: uiViewController.map,
                withMarkers: self.markers
            )
        } else {
            context.coordinator.updateCluster(withMarkers: self.markers)
        }
        
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

    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GMapsViewWrapper
        var isRouting: Bool = false
        var hasDrawen: Bool = false
        private(set) var circle: GMSCircle?
        private(set) var currentRoutePolyline: GMSPolyline?
        private(set) var markerA: GMSMarker?
        private(set) var markerB: GMSMarker?
        private(set) var clusterManager: GMUClusterManager?
        
        init(_ parent: GMapsViewWrapper) {
            self.parent = parent
        }
        
        func setupCluster(mapView: GMSMapView, withMarkers markers: [GMSMarker]) {
            let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
            let renderer = GMUDefaultClusterRenderer(
                mapView: mapView,
                clusterIconGenerator: GMUDefaultClusterIconGenerator()
            )
            
            clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
            clusterManager?.setMapDelegate(self)
            // Add markers to the cluster manager
            
            updateCluster(withMarkers: markers)
        }
        
        func updateCluster(withMarkers markers: [GMSMarker]) {
            clusterManager?.clearItems()
            markers.forEach { marker in
                clusterManager?.add(markers)
            }
            clusterManager?.cluster()
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let isCluster = marker.userData is GMUCluster

            if isCluster {
                mapView.animate(toLocation: marker.position)
                mapView.animate(toZoom: mapView.camera.zoom + 1)
                return true
            } else {
                return onClickStation(mapView, didTap: marker)
            }
        }
        
        private func onClickStation(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            let p = CLLocationCoordinate2D(latitude: marker.layer.latitude, longitude: marker.layer.longitude).toScreenPoint(on: mapView)
            let bottom: CGFloat = 158 - UIApplication.shared.safeArea.bottom// + (hasSafeArea ? UIApplication.shared.safeArea.bottom : 20)
            parent.onClickMarker?(marker, .init(x: p.x, y: p.y - bottom))
            return true
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            debugPrint("didTapAt coordinate \(coordinate)")
        }
        
        func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
            debugPrint("Did begin dragging")
        }
        
        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            debugPrint("Did end dragging")
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            debugPrint("Will move \(gesture)")
            removeCircle()

            if gesture {
                withAnimation(.default) {
                    self.parent.isDragging = true
                }
            }
        }
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            debugPrint("Stop move")
            
            withAnimation(.default) {
                self.parent.isDragging = false
            }
            
            readScreenCenterCoordinate(on: mapView)
            
//            if let l = self.parent.pickedLocation?.coordinate, !hasDrawen {
//                drawCircleByRadius(on: mapView, location: l, radius: parent.radius)
//            }
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            parent.camera = GMSCameraPosition(latitude: lat, longitude: lng, zoom: position.zoom, bearing: 0, viewingAngle: 45)
            
            let _radius = generateRadius(mapView)
            
            parent.onChangeVisibleArea?(_radius)
        }
        
        func generateRadius(_ mapView:GMSMapView) -> CGFloat {
            let centerPoint = mapView.center
            let centerCoordinate = mapView.projection.coordinate(for: centerPoint)
            let visibleRegion = mapView.projection.visibleRegion()
            
            let topLeftCoordinate = visibleRegion.nearLeft
            let topLeftLocation = CLLocation(latitude: topLeftCoordinate.latitude, longitude: topLeftCoordinate.longitude)
            
            let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
            
            let distanceInMeters = centerLocation.distance(from: topLeftLocation)
            let inMiles = distanceInMeters.f.asMile
            
            return inMiles
        }
        
        func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
            debugPrint("Did tap my location button")
            if let loc = mapView.myLocation {
                mapView.animate(toLocation: loc.coordinate)
            }
            return true
        }
        
        func show(polyline: GMSPolyline, on mapView: GMSMapView) {
            //add style to polyline
            polyline.strokeColor = UIColor.red
            polyline.strokeWidth = 4
            
            //add to map
            polyline.map = mapView
        }
        
        func clearRoute(onMap map: GMSMapView) {
            self.currentRoutePolyline?.map = nil
            self.currentRoutePolyline = nil
                        
            self.markerA?.map = nil
            self.markerA = nil
            
            self.markerB?.map = nil
            self.markerB = nil
        }
        
        func clearMarkers(onMap map: GMSMapView) {
            self.parent.markers.forEach { marker in
                marker.map = nil
            }
            
            self.parent.markers = []
        }
        
        func endDrawing() {
            self.hasDrawen = false
            self.isRouting = false
        }
        
        private func draw(route: [CLLocationCoordinate2D], on mapView: GMSMapView) {
            let path = GMSMutablePath()
            route.forEach { path.add($0) }
            self.currentRoutePolyline = GMSPolyline(path: path)
            self.currentRoutePolyline?.strokeColor = .systemGray
            self.currentRoutePolyline?.strokeWidth = 5
            self.currentRoutePolyline?.map = mapView
            self.hasDrawen = true
            self.isRouting = false
        }
        
        func setMapMarkersRoute(route: [CLLocationCoordinate2D], on mapView: GMSMapView) {
            guard !isRouting else {
                Logging.l("Cannot draw because It is already drawing the route \(isRouting)")
                return
            }
            
            guard !hasDrawen else {
                Logging.l("Cannot draw because It is already drawen the route \(hasDrawen)")
                return
            }
            
            self.isRouting = true
            
            DispatchQueue.main.async {
                let isDifferentA = self.markerA?.position != route.first
                let isDifferentB = self.markerB?.position != route.last
                
                if isDifferentA || isDifferentB {
                    self.clearRoute(onMap: mapView)
                    self.markerB?.map = nil
                    self.markerB = nil
                    self.markerA?.map = nil
                    self.markerA = nil
                }
                
                guard let toLoc = route.last, let vLoc = route.first else {
                    return
                }
                
                mainIfNeeded {
                    //add the markers for the 2 locations
                    
                    self.markerB = GMSMarker.init(position: toLoc)
                    self.markerB!.map = mapView
                    self.markerB!.iconView = UIImageView(image: UIImage(named: "icon_to_point"))
                    self.markerB!.iconView?.frame.size = .init(width: 24, height: 24)
                    
                    self.markerA = GMSMarker.init(position: vLoc)
                    self.markerA!.map = mapView
                    self.markerA!.iconView = UIImageView(image: UIImage(named: "icon_from_point"))
                    self.markerA!.iconView?.frame.size = .init(width: 24, height: 24)

                    //zoom the map to show the desired area
                    var bounds = GMSCoordinateBounds()
                    bounds = bounds.includingCoordinate(vLoc)
                    bounds = bounds.includingCoordinate(toLoc)
                    mapView.moveCamera(GMSCameraUpdate.fit(bounds))
                    
                    //finally get the route
                    self.draw(route: route, on: mapView)
                }
            }
        }
        
        func setupMarkers(onMap map: GMSMapView) {
            let region = map.projection.visibleRegion()

            self.parent.markers.forEach { marker in
                if region.contains(marker.position) {
                    if marker.map == nil {
                        marker.map = map
                    }
                } else {
                    if marker.map != nil {
                        marker.map = nil
                    }
                }
            }
        }
        
        func drawCircleByRadius(on mapView: GMSMapView, location: CLLocationCoordinate2D, radius: CLLocationDistance) {
            if circle != nil {
                // update circle
                circle?.radius = radius.f.asMeters
                circle?.map = mapView
                circle?.position = location
                return
            }
            
            // create circle
            circle = .init(position: location, radius: radius.f.asMeters)
            circle?.fillColor = UIColor(red: 0.35, green: 0, blue: 0, alpha: 0.05)
            circle?.strokeColor = .red
            circle?.strokeWidth = 2
            circle?.map = mapView
        }
        
        func removeCircle() {
            circle?.map = nil
            circle = nil
        }
        
        private func readScreenCenterCoordinate(on mapView: GMSMapView) {
            let hasSafeArea = UIApplication.shared.safeArea.bottom != .zero
            
            let bottom = 158 / 2 - UIApplication.shared.safeArea.bottom + (hasSafeArea ? UIApplication.shared.safeArea.bottom : 20)
            
            var center = mapView.center
            center.y -= bottom
            let coordinate = mapView.projection.coordinate(for: center)
            
            self.parent.pickedLocation = CLLocation.init(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            )
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
