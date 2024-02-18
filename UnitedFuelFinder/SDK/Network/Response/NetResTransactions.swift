//
//  NetResTransactions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/02/24.
//

import Foundation

public struct NetResTransactions: Codable {
    let id: Int
    let cardNumber: String
    let transactionDate: String
    let invoiceNumber: String?
    let unit: String?
    let driverName: String?
    let odometer: Int?
    let locationName: String?
    let city: String?
    let state: String?
    let fees: Double?
    let item: String?
    let unitPrice: Double?
    let discPpu: Double?
    let discCost: Double?
    let quantity: Double?
    let discAmount: Double?
    let discType: String?
    let amount: Double?
    let db: String?
    let currency: String?
    let hash: String?
    let fileName: String?
}
