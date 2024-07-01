//
//  DriverCard.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/06/24.
//

import Foundation

public struct DriverCard {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(res: NetResDriverCard) {
        self.id = res.id
        self.name = res.name
    }
}
