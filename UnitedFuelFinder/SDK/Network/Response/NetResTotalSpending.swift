//
//  NetResTotalSpending.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct NetResTotalSpending: NetResBody {
    let total: Double
    let records: [String: Double]
}


