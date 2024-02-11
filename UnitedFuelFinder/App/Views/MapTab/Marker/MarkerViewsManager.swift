//
//  MarkerViewsManager.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/12/23.
//

import Foundation

class MarkerViewManager {
    static let shared = MarkerViewManager()
    
    private var stationImages: Set<MarkerImageView> = []

    func stationImage(withIdentifier identifier: String) -> MarkerImageView? {
        if !stationImages.contains(where: {$0.id == identifier}) {
            stationImages.insert(.init(id: identifier, placeholder: nil))
        }
        
        return stationImages.first(where: {$0.id == identifier})
    }
    
    func clearAll() {
        stationImages.removeAll()
    }
}
