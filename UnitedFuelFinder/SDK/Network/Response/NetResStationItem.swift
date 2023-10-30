//
//  NetResStationItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

struct NetResStationItem: NetResBody {
    var id: Int
    var name: String
    var lat: Double
    var lng: Double
    var isDeleted: Bool
    var cityId: Int
    var companyId: Int
    var address: String?
    var phone: String?
    var stateId: String
    var discountPercent: Float?
    var retailPrice: Float?
    var iconUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lat
        case lng
        case isDeleted
        case cityId
        case companyId
        case address
        case phone
        case stateId
        case discountPercent
        case retailPrice
        case iconUrl = "icon_url"
    }
}
