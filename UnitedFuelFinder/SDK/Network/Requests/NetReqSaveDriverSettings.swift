//
//  NetReqSaveDriverSettings.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/06/24.
//

import Foundation

public struct NetReqSaveDriverSettings: Codable {
    let cardNumber: String
    let driverUnit: String
    let stations: [Int]
    let viewInvoices: Bool
    let viewTransactions: Bool
    let shownDiscountPrices: Bool
    let shownDiscountedPrices: Bool
    
    public init(cardNumber: String, driverUnit: String, stations: [Int], viewInvoices: Bool, viewTransactions: Bool, shownDiscountPrices: Bool, shownDiscountedPrices: Bool) {
        self.cardNumber = cardNumber
        self.driverUnit = driverUnit
        self.stations = stations
        self.viewInvoices = viewInvoices
        self.viewTransactions = viewTransactions
        self.shownDiscountPrices = shownDiscountPrices
        self.shownDiscountedPrices = shownDiscountedPrices
    }
}
