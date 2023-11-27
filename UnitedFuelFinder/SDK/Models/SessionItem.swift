//
//  SessionItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 23/11/23.
//

import Foundation

struct SessionItem: Identifiable {
    let id: Int?
    let agent: String?
    let ip: String?
    let driverId: String?
    let loginTime: String?
}

extension SessionItem {
    init(_ netRes: NetResSessionItem) {
        self.id = netRes.id
        self.agent = netRes.agent
        self.ip = netRes.ip
        self.driverId = netRes.driverId
        self.loginTime = netRes.loginTime
    }
    
    var date: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.serverFormat
        return formatter.date(from: loginTime ?? "")
    }
    
    var beautifiedDateTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd MMM yyyy"
        return formatter.string(from: date ?? Date())
    }
}
