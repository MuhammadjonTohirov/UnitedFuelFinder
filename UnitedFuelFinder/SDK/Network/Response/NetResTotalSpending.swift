//
//  NetResTotalSpending.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct NetResTotalSpending: NetResBody {
    public struct Item: Codable {
        let id: Int
        let name: String?
        let value: Double?
    }
    
    let total: Double
    let records: [Item]
}

