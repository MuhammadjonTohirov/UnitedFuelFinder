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
//  MapViewController.swift
//  GoogleMapsSwiftUI
//
//  Created by Chris Arriola on 2/5/21.
//

import GoogleMaps
import GoogleMapsUtils
import SwiftUI
import UIKit

class MapViewModel {
    
}

class MapViewController: UIViewController {
    
    lazy var map = {GMSMapView(frame: .zero)}()

    var isAnimating: Bool = false
    
    weak var delegate: GMSMapViewDelegate? {
        didSet {
            map.delegate = delegate
        }
    }
    
    private var viewModel: MapViewModel = .init()
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.addSubview(map)
        map.settings.compassButton = true
        map.settings.rotateGestures = false
        map.settings.allowScrollGesturesDuringRotateOrZoom = false
        map.settings.tiltGestures = true
        
        changeMapStyle(by: traitCollection.userInterfaceStyle)

        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        map.isBuildingsEnabled = true
        map.isMyLocationEnabled = true
        
//        let iconGenerator = GMUDefaultClusterIconGenerator()
//        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
//        let renderer = GMUDefaultClusterRenderer(mapView: map,
//                                                 clusterIconGenerator: iconGenerator)
//        clusterManager = GMUClusterManager(map: map, algorithm: algorithm,
//                                           renderer: renderer)
        
    }
    
    func set(padding: UIEdgeInsets) {
        self.map.padding = padding
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            changeMapStyle(by: traitCollection.userInterfaceStyle)
        }
    }
    
    private func changeMapStyle(by interface: UIUserInterfaceStyle) {
        switch interface {
        case .unspecified:
            map.mapStyle = try! GMSMapStyle.init(jsonString: GMapStyles.default)
        case .light:
            map.mapStyle = try! GMSMapStyle.init(jsonString: GMapStyles.default)
        case .dark:
            map.mapStyle = try! GMSMapStyle.init(jsonString: GMapStyles.night)
        @unknown default:
            break
        }
    }
}
