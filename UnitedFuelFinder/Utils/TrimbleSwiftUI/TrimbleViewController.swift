//
//  TrimbleViewController.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI
import TrimbleMaps
import TrimbleMapsAccounts

class TrimbleViewController: UIViewController {
    var mapView: TMGLMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTrimble()
    }
    
    private func setupTrimble() {
        let account = Account(
            apiKey: "ED02873C8E2F8542969B2349FD98445F",
            region: Region.northAmerica
        )
        
        AccountManager.default.account = account
        AccountManager.default.delegate = self
    }
}

extension TrimbleViewController: AccountManagerDelegate {
    func stateChanged(newStatus: TrimbleMapsAccounts.AccountManagerState) {
        Logging.l(newStatus)
        
        if newStatus == .loaded {
            mainIfNeeded {
                self.mapView = TMGLMapView(frame: self.view.bounds)
                
                let centerCoordinate = CLLocationCoordinate2D(
                    latitude: 40.7128, 
                    longitude: -74.0060
                )
                
                let camera = TMGLMapCamera(
                    lookingAtCenter:centerCoordinate,
                    altitude: 500,
                    pitch: 15,
                    heading: 180
                )
                
                self.mapView.camera = camera
                
                self.view.addSubview(self.mapView)
            }
        }
    }
}
