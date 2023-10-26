//
//  NetReqLogin.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

//{
//  "email": "user@example.com",
//  "confirm": {
//    "code": "string",
//    "session": "string"
//  }
//}

struct NetReqLogin: Codable {
    let email: String
    let confirm: NetReqLoginConfirm
}

struct NetReqLoginConfirm: Codable {
    let code: String // code coming from OTP
    let session: String // session key coming from verify account
}


