//
//  GMapsViewCoordinator+Cluster.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/03/24.
//

import Foundation
import GoogleMaps
import GoogleMapsUtils

extension GMapsViewWrapper.Coordinator {
    
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
           
}
