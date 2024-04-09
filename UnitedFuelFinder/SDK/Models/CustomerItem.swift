//
//  CustomerItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/11/23.
//

import Foundation
import UIKit

public struct CustomerItem {
    public let id: Int
    public let name: String
    public let email: String?
    public let phone: String?
    public let cityId: Int?
    public let stateId: String?
    public let address: String?
    public let isDeleted: Bool?
    public let iconUrl: String?
    public let logoUrl: String?
    public let markerColor: String?
}

extension CustomerItem {
    static func create(from item: NetResCustomerItem) -> CustomerItem {
        return CustomerItem(id: item.id, name: item.name, email: item.email, phone: item.phone, cityId: item.cityId, stateId: item.stateId, address: item.address, isDeleted: item.isDeleted, iconUrl: item.iconUrl, logoUrl: item.logoUrl, markerColor: item.markerColor)
    }
    
    var colorCode: UIColor {
        let code = markerColor ?? "#0f0f0f"
        return .init(hexString: code)
    }
}
