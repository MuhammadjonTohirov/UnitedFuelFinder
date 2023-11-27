//
//  AuditLog.swift
//  UnitedFuelFinder
//
//  Created by applebro on 25/11/23.
//

import Foundation

struct AuditLog {
    let id: Int?
    let action: String?
    let note: String?
    let time: String?
    let userId: String?
    
    init(id: Int?, action: String?, note: String?, time: String?, userId: String?) {
        self.id = id
        self.action = action
        self.note = note
        self.time = time
        self.userId = userId
    }
}

extension AuditLog {
    init(_ netRes: NetResAuditLog) {
        self.id = netRes.id
        self.action = netRes.action
        self.note = netRes.note
        self.time = netRes.time
        self.userId = netRes.userId
    }
    
    var date: Date? {
        guard let time else {
            return nil
        }
        
        return Date.from(string: time)
    }
    
    var dateInfo: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm dd MMM yyyy"
        return formatter.string(from: date ?? Date())
    }
}
