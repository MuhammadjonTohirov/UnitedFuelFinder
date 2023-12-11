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

    fileprivate var onStartDrawing: (() -> Void)?
    fileprivate var onEndDrawing: ((Bool) -> Void)?
    fileprivate var onClickMarker: ((_ marker: GMSMarker, _ frame: CGPoint) -> Void)?
    fileprivate var routeFrom: CLLocationCoordinate2D?
    fileprivate var routeTo: CLLocationCoordinate2D?
    fileprivate var didRadiusChanged: Bool = true

    fileprivate var radius: CLLocationDistance = .zero
    
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
    
    func set(currentLocation: CLLocation?) -> Self {
        var v = self
        v.location = currentLocation
        return v
    }
    
    func set(from: CLLocationCoordinate2D?, to: CLLocationCoordinate2D?, onStartDrawing: @escaping () -> Void, onEndDrawing: @escaping (Bool) -> Void) -> Self {
        var v = self
        
        if v.routeFrom != from {
            v.routeFrom = from
        }
        
        if v.routeTo != to {
            v.routeTo = to
        }
        
        v.onStartDrawing = onStartDrawing
        v.onEndDrawing = onEndDrawing
        
        return v
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let mapController = MapViewController()
        mapController.delegate = context.coordinator
        
        let hasSafeArea = UIApplication.shared.safeArea.bottom != .zero
        
        let bottom = 158 - UIApplication.shared.safeArea.bottom + (hasSafeArea ? UIApplication.shared.safeArea.bottom : 20)
        
        mapController.set(padding: .init(
            top: 0, left: 0,
            bottom: bottom, right: 0))
        
        return mapController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        Logging.l("MapView update ui called")
        if let location {
            let position = GMSCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 15)
            
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
        
        if let from = self.routeFrom, let to = self.routeTo {
            context.coordinator.setMapMarkersRoute(vLoc: from, toLoc: to, on: uiViewController.map)
        } else {
            context.coordinator.clearRoute(onMap: uiViewController.map)
            context.coordinator.endDrawing()
        }
        
//       MARK: Radius change
        if didRadiusChanged, let coordinate = self.pickedLocation?.coordinate {
            if radius > 0 {
                context.coordinator.drawCircleByRadius(on: uiViewController.map, location: coordinate, radius: radius)
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
            mapView.animate(toLocation: marker.position)

            if isCluster {
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
            
            if mapView.selectedMarker == nil {
                mapView.selectedMarker = marker
            } else {
                mapView.selectedMarker = nil
            }
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
            if let l = self.parent.pickedLocation?.coordinate {
                drawCircleByRadius(on: mapView, location: l, radius: parent.radius)
            }
            
            let lat = position.target.latitude
            let lng = position.target.longitude
            
            parent.camera = GMSCameraPosition(latitude: lat, longitude: lng, zoom: position.zoom, bearing: 0, viewingAngle: 45)
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
            guard currentRoutePolyline != nil else {
                return
            }
            
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
        
        func getRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, on mapView: GMSMapView) {
            Logging.l("Start routing \(isRouting) \nfrom: \(from) \nto: \(to)")
            let origin = "\(from.latitude),\(from.longitude)"
            let destination = "\(to.latitude),\(to.longitude)"
                        
            if let url = URL.googleRoutingAPI(from: origin, to: destination) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil else {
                        debugPrint("Error fetching directions: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let routes = json?["routes"] as? [[String: Any]], let route = routes.first, let polyline = route["overview_polyline"] as? [String: Any], let points = polyline["points"] as? String {
                            // Decode the polyline and draw it on the map
                            DispatchQueue.main.async {
                                let path = GMSPath(fromEncodedPath: points)
                                let polyline = GMSPolyline(path: path)
                                polyline.strokeColor = .systemGray
                                polyline.strokeWidth = 4
                                polyline.map = mapView

                                self.currentRoutePolyline = polyline
                                self.parent.onEndDrawing?(true)
                                self.hasDrawen = true
                                self.isRouting = false
                            }
                        } else {
                            debugPrint("No routes found")
                            self.parent.onEndDrawing?(false)
                            self.hasDrawen = false
                            self.isRouting = false
                        }
                    } catch let error {
                        debugPrint("Error decoding directions: \(error.localizedDescription)")
                    }
                }.resume()
            }
        }
        
        func setMapMarkersRoute(vLoc: CLLocationCoordinate2D, toLoc: CLLocationCoordinate2D, on mapView: GMSMapView) {
            guard !isRouting else {
                Logging.l("Cannot draw because It is already drawing the route \(isRouting)")
                return
            }
            
            guard !hasDrawen else {
                Logging.l("Cannot draw because It is already drawen the route \(hasDrawen)")
                return
            }

            self.parent.onStartDrawing?()

            self.isRouting = true
            
            DispatchQueue.main.async {
                self.clearRoute(onMap: mapView)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    //add the markers for the 2 locations
                    self.markerB?.map = nil
                    self.markerB = nil
                    self.markerA?.map = nil
                    self.markerA = nil
                    
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
                    self.getRoute(from: vLoc, to: toLoc, on: mapView)
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
                Logging.l(tag: "GMapsView", "Update circle by \(radius)")
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
