//
//  CompanyItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/11/23.
//

import Foundation
import RealmSwift

public struct CompanyItem: Objectify {
    var id: Int
    var name: String
    var email: String
    var phone: String
    var cityId: Int
    var stateId: String?
    var address: String
    var isDeleted: Bool
    var logoUrl: String?
    
    init(id: Int, name: String, email: String, phone: String, cityId: Int, stateId: String?, address: String, isDeleted: Bool, logoUrl: String? = nil) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.cityId = cityId
        self.stateId = stateId
        self.address = address
        self.isDeleted = isDeleted
        self.logoUrl = logoUrl
    }
    
    init(res: NetResCompany) {
        self.id = res.id
        self.name = res.name
        self.email = res.email
        self.phone = res.phone
        self.cityId = res.cityId
        self.stateId = res.stateId
        self.address = res.address
        self.isDeleted = res.isDeleted
        self.logoUrl = res.logoUrl
    }
    
    var asObject: Object {
        DCompany(item: self)
    }
}
