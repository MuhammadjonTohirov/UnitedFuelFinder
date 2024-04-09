//
//  NetResCustomerItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/11/23.
//

import Foundation

struct NetResCustomerItem: NetResBody {
    let id: Int
    let name: String
    let email: String?
    let phone: String?
    let cityId: Int?
    let stateId: String?
    let address: String?
    let isDeleted: Bool?
    let iconUrl: String?
    let logoUrl: String?
    let markerColor: String?
}
