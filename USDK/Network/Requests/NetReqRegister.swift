//
//  NetReqRegister.swift
//  USDK
//
//  Created by applebro on 23/10/23.
//

import Foundation

public struct NetReqRegister: Codable {
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let cardNumber: String
    let confirm: NetReqRegisterConfirm
    
    public init(firstName: String, lastName: String, phone: String, email: String, cardNumber: String, code: String, session: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.cardNumber = cardNumber
        self.confirm = .init(code: code, session: session)
    }
}

struct NetReqRegisterConfirm: Codable {
    let code: String // code coming from OTP
    let session: String // session key coming from verify account
}
