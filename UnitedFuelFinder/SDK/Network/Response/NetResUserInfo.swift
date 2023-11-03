//
//  NetResUserInfo.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation

//{
//    "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
//    "fullName": "string",
//    "email": "string",
//    "phone": "string",
//    "cardNumber": "string",
//    "companyId": 0,
//    "companyName": "string",
//    "address": "string",
//    "cityId": 0,
//    "cityName": "string",
//    "state": "string",
//    "confirmed": true,
//    "deleted": true
//  }

struct NetResUserInfo: NetResBody {
    let id: String?
    let fullName: String
    let email: String
    let phone: String
    let cardNumber: String
    let companyId: Int?
    let companyName: String?
    let address: String?
    let cityId: Int?
    let cityName: String?
    let state: String?
    let confirmed: Bool?
    let deleted: Bool?
}
