//
//  NetResInvoiceItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct NetResInvoiceItem: NetResBody {
    let id: Int
    let companyAccountId: Int
    let invoiceNumber: String?
    let isSentToEmail: Bool?
    let startPeriod: String?
    let endPeriod: String?
    let totalDiscount: Double?
    let totalFees: Double?
    let totalAmount: Double
    let totalPaid: Double?
    let remainingAmount: Int?
    let additionalCharge: Int?
    let bonus: Int?
    let invoiceDate: String?
    let dueDate: String?
    let lastPaymentDate: String?
    let lastPaymentNote: String?
    let status: String?
    let notes: String?
    let companyAccount: NetResCompanyAccount?
    let totalDiscountedGallons: Double?
    let averageDiscountPerGallon: Double?
    let discountEditedInfo: String?
}

public struct NetResCompanyAccount: Codable {
    let id: Int
    let name: String?
}

public struct NetResOrganization: Codable {
    let id: Int
    let name: String
}


