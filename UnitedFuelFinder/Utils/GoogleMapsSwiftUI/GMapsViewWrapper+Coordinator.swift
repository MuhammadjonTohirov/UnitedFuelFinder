//
//  GMapsViewwrapper+Coordinator.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/03/24.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils
import SwiftUI

extension GMapsViewWrapper {
    class Coordinator: NSObject, GMSMapViewDelegate {
        var parent: GMapsViewWrapper
        var isRouting: Bool = false
        var hasDrawen: Bool = false
        
        var circle: GMSCircle?
        var currentRoutePolyline: GMSPolyline?
        var markerA: GMSMarker?
        var markerB: GMSMarker?
        var clusterManager: GMUClusterManager?
        
        init(_ parent: GMapsViewWrapper) {
            self.parent = parent
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
        
        func setupMarkers(onMap map: GMSMapView, withMarkers markers: Set<GMSMarker>) {
            let region = map.projection.visibleRegion()

            markers.forEach { marker in
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
                circle?.radius = radius
                circle?.map = mapView
                circle?.position = location
                return
            }
            
            // create circle
            circle = .init(position: location, radius: radius)
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
