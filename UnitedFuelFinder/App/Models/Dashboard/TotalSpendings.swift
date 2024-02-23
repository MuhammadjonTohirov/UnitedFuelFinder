//
//  TotalSpendings.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

enum TotalSpendingFilterType: Int {
    case today
    case week
    case month
}

class TotalSpendings {
    var type: TotalSpendingFilterType = .today
    var total: Double = 0
    var records: [String: Double] = [:]
    
    init(type: TotalSpendingFilterType, total: Double, records: [String : Double]) {
        self.type = type
        self.total = total
        self.records = records
    }
}
