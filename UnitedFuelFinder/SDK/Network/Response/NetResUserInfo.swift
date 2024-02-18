//
//  NetResUserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

struct NetResUserInfo: NetResBody {
    let id: String?
    let fullName: String
    
    let firstName: String?
    let lastName: String?
    
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
}

