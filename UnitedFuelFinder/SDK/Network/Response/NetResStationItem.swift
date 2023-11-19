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
//      "discountPrice": 0,
//      "retailPrice": 0,
//      "priceUpdated": "2023-11-15T19:59:23.289Z",
//      "number": "string",
//      "note": "string",
//      "logoUrl": "string"
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
    var discountPrice: Float?
    var priceUpdated: String
    var retailPrice: Float?
    var number: String?
    var logoUrl: String?
    var note: String?
    
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
        case discountPrice
        case priceUpdated
        case retailPrice
        case number
        case note
        case logoUrl = "logoUrl"
    }
}
