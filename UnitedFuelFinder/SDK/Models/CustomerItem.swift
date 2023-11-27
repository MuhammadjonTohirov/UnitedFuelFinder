//
//  CustomerItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/11/23.
//

import Foundation

struct CustomerItem {
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

extension CustomerItem {
    static func create(from item: NetResCustomerItem) -> CustomerItem {
        return CustomerItem(id: item.id, name: item.name, email: item.email, phone: item.phone, cityId: item.cityId, stateId: item.stateId, address: item.address, isDeleted: item.isDeleted, iconUrl: item.iconUrl, logoUrl: item.logoUrl, markerColor: item.markerColor)
    }
}
