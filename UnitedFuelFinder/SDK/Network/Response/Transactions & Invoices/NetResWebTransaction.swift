//
//  NetResCompanyTransaction.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/07/24.
//

import Foundation

struct NetResWebTransaction: NetResBody {
    let items: [NetResTransactions]
    let pageNumber: Int?
    let totalPages: Int?
    let totalCount: Int?
    let hasPreviousPage: Bool?
    let hasNextPage: Bool?
}
