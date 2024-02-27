//
//  InvoiceItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

struct InvoiceItem: Identifiable {
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
    
    init(from: NetResInvoiceItem) {
        self.id = from.id
        self.companyAccountId = from.companyAccountId
        self.invoiceNumber = from.invoiceNumber
        self.isSentToEmail = from.isSentToEmail
        self.startPeriod = from.startPeriod
        self.endPeriod = from.endPeriod
        self.totalDiscount = from.totalDiscount
        self.totalFees = from.totalFees
        self.totalAmount = from.totalAmount
        self.totalPaid = from.totalPaid
        self.remainingAmount = from.remainingAmount
        self.additionalCharge = from.additionalCharge
        self.bonus = from.bonus
        self.invoiceDate = from.invoiceDate
        self.dueDate = from.dueDate
        self.lastPaymentDate = from.lastPaymentDate
        self.lastPaymentNote = from.lastPaymentNote
        self.status = from.status
        self.notes = from.notes
        self.companyAccount = from.companyAccount
        self.totalDiscountedGallons = from.totalDiscountedGallons
        self.averageDiscountPerGallon = from.averageDiscountPerGallon
        self.discountEditedInfo = from.discountEditedInfo
    }
}

struct CompanyAccount {
    let id: Int
    let accountName: String?
    let name: String
    let organization: OrganizationItem
    
    init(from: NetResCompanyAccount) {
        self.id = from.id
        self.accountName = from.accountName
        self.name = from.name
        self.organization = .init(from: from.organization)
    }
}

struct OrganizationItem {
    let id: Int
    let name: String
    
    init(from: NetResOrganization) {
        self.id = from.id
        self.name = from.name
    }
}

extension InvoiceItem {
    var beatufiedDate: String {
        Date.from(string: self.invoiceDate ?? "", format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy") ?? "-"
    }
}
