//
//  NetResLogin.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

public struct NetResLogin: NetResBody {
    public let accessToken: String
    public let expiresIn: Double
    public let refreshToken: String
    public let refreshExpiresIn: Double
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
        case refreshExpiresIn = "refresh_expires_in"
        case scope
    }
}
