//
//  ShortStorage.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/04/24.
//

import Foundation

struct ShortStorage {
    static var `default`: ShortStorage = .init()
    
    @codableWrapper(key: "costumers", nil)
    var customers: [NetResCustomerItem]?
}
