//
//  CardItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/07/24.
//

import Foundation

public struct CardModelItem {
    public let companyName: String
    public let cardNumber: String
    public let accountName: String
    public let totalBalance: Double
    public let color: String?
    
    public init(companyName: String, cardNumber: String, accountName: String, totalBalance: Double, color: String?) {
        self.companyName = companyName
        self.cardNumber = cardNumber
        self.accountName = accountName
        self.totalBalance = totalBalance
        self.color = color
    }
    
    public init(res: NetResCard) {
        self.companyName = res.companyName
        self.cardNumber = res.cardNumber
        self.accountName = res.accountName
        self.totalBalance = res.totalBalance
        self.color = res.color
    }
}
