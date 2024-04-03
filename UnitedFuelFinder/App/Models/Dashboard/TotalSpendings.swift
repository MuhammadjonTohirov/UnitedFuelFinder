//
//  TotalSpendings.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation
import UIKit

enum TotalSpendingFilterType: Int {
    case today
    case week
    case month
}

class TotalSpendings {
    var type: TotalSpendingFilterType = .today
    var total: Double = 0
    var records: [TotalSpendings.Record] = []
    
    init(type: TotalSpendingFilterType, total: Double, records: [TotalSpendings.Record]) {
        self.type = type
        self.total = total
        self.records = records
    }
    
    struct Record {
        var id: Int
        var name: String
        var value: Double
    }
}

extension TotalSpendings {
    static func from(res netResTotalSpending: NetResTotalSpending, type: TotalSpendingFilterType) -> TotalSpendings {
        let records = netResTotalSpending.records.map { record in
            return TotalSpendings.Record(id: record.id, name: record.name ?? "", value: record.value ?? 0)
        }
        return TotalSpendings(type: type, total: netResTotalSpending.total, records: records)
    }
}

extension TotalSpendings.Record {
    var customer: CustomerItem? {
        // TODO: filter by id
        if let r = ShortStorage.default.customers?.first {
            return .create(from: r)
        }
        
        return nil
    }
    
    var color: UIColor {
        customer?.colorCode ?? .label
    }
}
