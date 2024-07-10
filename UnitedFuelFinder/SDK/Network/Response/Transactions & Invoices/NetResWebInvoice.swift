//
//  NetResTransactionList.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/07/24.
//

import Foundation

struct NetResWebInvoices: NetResBody {
    let items: [NetResInvoiceItem]
    let pageNumber: Int?
    let totalPages: Int?
    let totalCount: Int?
    let hasPreviousPage: Bool?
    let hasNextPage: Bool?
}
