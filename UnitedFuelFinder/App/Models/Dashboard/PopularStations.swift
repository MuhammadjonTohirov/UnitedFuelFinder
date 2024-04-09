//
//  PopularStations.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct PopularStationItem: NetResBody {
    let id: Int
    let customerName: String
    let station: String
    let value: Int
}

public struct PopularStations: NetResBody {
    var total: Int
    var rows: [PopularStationItem]
}

extension PopularStationItem {
    var customer: CustomerItem? {
        if let r = ShortStorage.default.customers?.first(where: {$0.id == id}) {
            return .create(from: r)
        }
        
        return nil
    }
}
