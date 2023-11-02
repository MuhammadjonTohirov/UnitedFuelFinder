//
//  NetResCompany.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/11/23.
//

import Foundation

struct NetResCompany: NetResBody {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var cityId: Int
    var stateId: String?
    var address: String
    var isDeleted: Bool
    var logoUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case phone
        case cityId
        case stateId
        case address
        case isDeleted
        case logoUrl
    }
}
