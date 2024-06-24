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
    
    public static func mockItems()->[InvoiceItem]{
        let item = InvoiceItem(from: NetResInvoiceItem(id: 1, companyAccountId: 1, invoiceNumber: "234-MNO", isSentToEmail: true, startPeriod: "01.02.2022", endPeriod: "01.02.2024", totalDiscount: 5.3, totalFees: 3.4, totalAmount: 8.2, totalPaid: 7.9, remainingAmount: 8, additionalCharge: 9, bonus: 1, invoiceDate: "01.02.2022", dueDate: "01.02.2024", lastPaymentDate: "01.02.2024", lastPaymentNote: "Note", status: "success", notes: "notes", companyAccount: nil, totalDiscountedGallons: 2, averageDiscountPerGallon: 5, discountEditedInfo: "Test"))

        let item2 = InvoiceItem(from: NetResInvoiceItem(id: 9, companyAccountId: 1, invoiceNumber: "1234 -NOC", isSentToEmail: true, startPeriod: "01.02.2020", endPeriod: "01.02.2022", totalDiscount: 5.3, totalFees: 3.4, totalAmount: 8.2, totalPaid: 7.9, remainingAmount: 8, additionalCharge: 9, bonus: 1, invoiceDate: "01.02.2020", dueDate: "01.02.2020", lastPaymentDate: "01.02.2024", lastPaymentNote: "Note2", status: "success", notes: "notes", companyAccount: nil, totalDiscountedGallons: 2, averageDiscountPerGallon: 5, discountEditedInfo: "Test"))

        
        return [item, item2]
    }
    
}

struct CompanyAccount {
    let id: Int
    let name: String
    
    init(from: NetResCompanyAccount) {
        self.id = from.id
        self.name = from.name ?? ""
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
    
    var fromDate: String {
        Date.from(string: self.startPeriod ?? "", format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy") ?? "-"
    }
    
    var toDate: String {
        Date.from(string: self.endPeriod ?? "", format: "yyyy-MM-dd'T'HH:mm:ss")?.toString(format: "dd/MM/yyyy") ?? "-"
    }
    
    var fromToDate: String {
        "\(fromDate) - \(toDate)"
    }
}
