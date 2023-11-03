//
//  NetReqRegister.swift
//  USDK
//
//  Created by applebro on 23/10/23.
//

import Foundation

//{
//  "firstName": "string",
//  "lastName": "string",
//  "phone": "string",
//  "email": "user@example.com",
//  "cardNumber": "string",
//  "state": "string",
//  "city": 0,
//  "companyId": 0,
//  "address": "string",
//  "zip": "string",
//  "confirm": {
//    "code": "string",
//    "session": "string"
//  }
//}

public struct NetReqRegister: Codable {
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let cardNumber: String
    let state: String
    let city: Int
    let companyId: Int
    let address: String
    let confirm: NetReqRegisterConfirm
    
    init(firstName: String, lastName: String, phone: String, email: String, cardNumber: String, state: String, city: Int, address: String, companyId: Int, confirm: NetReqRegisterConfirm) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.cardNumber = cardNumber
        self.state = state
        self.city = city
        self.address = address
        self.companyId = companyId
        self.confirm = confirm
    }
}

struct NetReqRegisterConfirm: Codable {
    let code: String // code coming from OTP
    let session: String // session key coming from verify account
}
