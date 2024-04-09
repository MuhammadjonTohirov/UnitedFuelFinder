//
//  NetReqChangePassword.swift
//  UnitedFuelFinder
//
//  Created by applebro on 02/04/24.
//

import Foundation

struct NetReqChangePassword: Codable {
    let oldPassword: String
    let newPassword: String
    let confirmPassword: String
}
