//
//  NetResUserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

struct NetResUserInfo: NetResBody {
    let id: String?
    let fullName: String?
    
    let firstName: String?
    let lastName: String?
    
    let email: String?
    let phone: String?
    let cardNumber: String?
    let companyId: Int?
    let companyName: String?
    let address: String?
    let cityId: Int?
    let cityName: String?
    let state: String?
    let stateId: String?
    let stateName: String?
    let confirmed: Bool?
    let deleted: Bool?
    var permissionList: [String]?
    let registerTime: String?
    let driverUnit: String?
    let accountId: Int?
    let accountName: String?
    let efsAccountId: Int?
    let efsAccountName: String?
    var includeStations: [String]?
    var roleCode: String?
}

