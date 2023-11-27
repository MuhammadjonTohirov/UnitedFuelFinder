//
//  NetResAuditLog.swift
//  UnitedFuelFinder
//
//  Created by applebro on 25/11/23.
//

import Foundation

//{
//      "id": 0,
//      "action": "string",
//      "note": "string",
//      "time": "2023-11-25T09:18:32.857Z",
//      "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6"
//    }

struct NetResAuditLog: NetResBody {
    let id: Int?
    let action: String?
    let note: String?
    let time: String?
    let userId: String?
}
