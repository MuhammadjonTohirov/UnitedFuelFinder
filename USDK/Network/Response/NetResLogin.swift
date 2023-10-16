//
//  NetResLogin.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

//{
//    "access_token": "string",
//    "expires_in": 0,
//    "refresh_expires_in": 0,
//    "refresh_token": "string",
//    "token_type": "string",
//    "not-before-policy": 0,
//    "session_state": "string",
//    "scope": "string"
//  }

public struct NetResLogin: NetResBody {
    public let accessToken: String
    public let expiresIn: Int
    public let refreshToken: String
    public let tokenType: String
    public let notBeforePolicy: Int
    public let sessionState: String
    public let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case tokenType = "token_type"
        case notBeforePolicy = "not-before-policy"
        case sessionState = "session_state"
        case scope
    }
}
