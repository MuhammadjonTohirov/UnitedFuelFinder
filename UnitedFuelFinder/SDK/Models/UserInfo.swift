//
//  UserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

public struct UserInfo: Codable {
    let id: String?
    let fullName: String
    
    var firstName: String?
    var lastName: String?
    
    let email: String
    let phone: String
    let cardNumber: String
    let companyId: Int?
    let companyName: String?
    let address: String?
    let cityId: Int?
    let cityName: String?
    let state: String?
    let stateId: String?
    let confirmed: Bool?
    let deleted: Bool?
    
    init(id: String?, fullName: String, email: String, phone: String, cardNumber: String, companyId: Int?, companyName: String?, address: String?, cityId: Int?, cityName: String?, state: String?, stateId: String?, confirmed: Bool?, deleted: Bool?) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phone = phone
        self.cardNumber = cardNumber
        self.companyId = companyId
        self.companyName = companyName
        self.address = address
        self.cityId = cityId
        self.cityName = cityName
        self.state = state
        self.confirmed = confirmed
        self.deleted = deleted
        self.stateId = stateId
    }
    
    init(res: NetResUserInfo) {
        self.id = res.id
        self.fullName = res.fullName
        self.email = res.email
        self.phone = res.phone
        self.cardNumber = res.cardNumber
        self.companyId = res.companyId
        self.companyName = res.companyName
        self.address = res.address
        self.cityId = res.cityId
        self.cityName = res.cityName
        self.state = res.state
        self.confirmed = res.confirmed
        self.deleted = res.deleted
        self.firstName = res.firstName
        self.lastName = res.lastName
        self.stateId = res.stateId
    }
}
