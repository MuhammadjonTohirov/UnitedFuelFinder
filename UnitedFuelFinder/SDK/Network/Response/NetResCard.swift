//
//  NetResCard.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

public struct NetResCard: NetResBody {
    let companyName: String
    let cardNumber: String
    let accountName: String
    let totalBalance: Double
}


public struct NetResActualVersion: NetResBody {
    let version: String?
    let baseUrl: String?
    let title: String?
    let description: String?
    let ios: String?
}
