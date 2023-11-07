//
//  File.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/11/23.
//

import Foundation

struct NetReqEditProfile: Encodable {
    var firstName: String
    var lastName: String
    var phone: String
    var state: String
    var city: Int
    var address: String
    
    init(firstName: String, lastName: String, phone: String, state: String, city: Int, address: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.state = state
        self.city = city
        self.address = address
    }
}
