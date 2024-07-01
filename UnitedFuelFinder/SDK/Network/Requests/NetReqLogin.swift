//
//  NetReqLogin.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

struct NetReqLogin: Codable {
    let email: String
    let password: String
    let role: String // driver, company, admin
}
