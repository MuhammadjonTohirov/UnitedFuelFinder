//
//  TransactionItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

struct TransactionItem: Identifiable {
    var id: Int
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
    
    init(from: NetResTransactions) {
        self.id = from.id
        self.cardNumber = from.cardNumber
        self.transactionDate = from.transactionDate
        self.invoiceNumber = from.invoiceNumber
        self.unit = from.unit
        self.driverName = from.driverName
        self.odometer = from.odometer
        self.locationName = from.locationName
        self.city = from.city
        self.state = from.state
        self.fees = from.fees
        self.item = from.item
        self.unitPrice = from.unitPrice
        self.discPpu = from.discPpu
        self.discCost = from.discCost
        self.quantity = from.quantity
        self.discAmount = from.discAmount
        self.discType = from.discType
        self.amount = from.amount
        self.db = from.db
        self.currency = from.currency
        self.hash = from.hash
        self.fileName = from.fileName
    }
    
    init(id: Int, cardNumber: String, transactionDate: String, invoiceNumber: String?, unit: String?, driverName: String?, odometer: Int?, locationName: String?, city: String?, state: String?, fees: Double?, item: String?, unitPrice: Double?, discPpu: Double?, discCost: Double?, quantity: Double?, discAmount: Double?, discType: String?, amount: Double?, db: String?, currency: String?, hash: String?, fileName: String?) {
        self.id = id
        self.cardNumber = cardNumber
        self.transactionDate = transactionDate
        self.invoiceNumber = invoiceNumber
        self.unit = unit
        self.driverName = driverName
        self.odometer = odometer
        self.locationName = locationName
        self.city = city
        self.state = state
        self.fees = fees
        self.item = item
        self.unitPrice = unitPrice
        self.discPpu = discPpu
        self.discCost = discCost
        self.quantity = quantity
        self.discAmount = discAmount
        self.discType = discType
        self.amount = amount
        self.db = db
        self.currency = currency
        self.hash = hash
        self.fileName = fileName
    }
}
