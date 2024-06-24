//
//  NetReqRegister.swift
//  USDK
//
//  Created by applebro on 23/10/23.
//

import Foundation

//{
//{
//  "firstName": "string",
//  "lastName": "string",
//  "phone": "string",
//  "email": "user@example.com",
//  "password": "string",
//  "cardNumber": "string",
//  "companyName": "string",
//  "state": "string",
//  "city": 0,
//  "address": "string",
//  "captcha": "string"
//}
//}

public struct NetReqRegister: Codable {
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let password: String
    //let cardNumber: String
    let state: String?
    let city: Int?
    let companyName: String
    let address: String?
    
    init(firstName: String, lastName: String, phone: String, email: String, password: String, cardNumber: String, state: String?, city: Int?, address: String?, companyName: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        //self.cardNumber = cardNumber
        self.state = state
        self.city = city
        self.address = address
        self.companyName = companyName
        self.password = password
    }
}
