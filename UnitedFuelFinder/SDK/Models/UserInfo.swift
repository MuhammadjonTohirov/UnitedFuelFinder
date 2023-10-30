//
//  UserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

public struct UserInfo: Codable {
    let id: String
    let fullName: String
    let email: String
    let phone: String
    let cardNumber: String
    let address: String
    let city: Int
    let state: String
    let zip: String
    let confirmed: Bool
    let deleted: Bool
    
    public init(id: String, fullName: String, email: String, phone: String, cardNumber: String, address: String, city: Int, state: String, zip: String, confirmed: Bool, deleted: Bool) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.cardNumber = cardNumber
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.confirmed = confirmed
        self.deleted = deleted
    }
    
    init(res: NetResUserInfo) {
        self.id = res.id ?? res.email
        self.fullName = res.fullName
        self.email = res.email
        self.phone = res.phone
        self.cardNumber = res.cardNumber
        self.address = res.address
        self.city = res.city
        self.state = res.state
        self.zip = res.zip
        self.confirmed = res.confirmed ?? true
        self.deleted = res.deleted ?? false
    }
}
