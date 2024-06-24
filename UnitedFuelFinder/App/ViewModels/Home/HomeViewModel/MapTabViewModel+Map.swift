//
//  MapTabViewModel+Map.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/06/24.
//

import Foundation
import CoreLocation

extension MapTabViewModel {
    func onClickResetMap() {
        self.state = .default

        self.clearDestination()

        self.focusToCurrentLocation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.startFilterStations()
        }

        delegate?.onResetMap(viewModel: self)
    }
    
    func removeDestinations() {
        self.destinations.removeAll()
    }
    
    func clearDestination() {
        mainIfNeeded {
            self.hasDrawen = false
            self.removeDestinations()
            self.removeMarkers()
            self.removeStations()

            self.mapRoute = []
            MapTabUtils.shared.mapPoints = nil
        }
    }
}
