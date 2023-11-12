//
//  NetResStationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

//{
//      "id": 0,
//      "name": "string",
//      "lat": 0,
//      "lng": 0,
//      "isDeleted": true,
//      "cityId": 0,
//      "customerId": 0,
//      "address": "string",
//      "phone": "string",
//      "stateId": "string",
//      "discountPercent": 0,
//      "retailPrice": 0,
//      "number": "string"
//    }

struct NetResStationItem: NetResBody {
    var id: Int
    var name: String
    var lat: Double
    var lng: Double
    var isDeleted: Bool
    var cityId: Int
    var customerId: Int
    var address: String?
    var phone: String?
    var stateId: String?
    var discountPercent: Float?
    var retailPrice: Float?
    var number: String?
    var iconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lat
        case lng
        case isDeleted
        case cityId
        case customerId
        case address
        case phone
        case stateId
        case discountPercent
        case retailPrice
        case number
        case iconUrl = "icon_url"
    }
}
