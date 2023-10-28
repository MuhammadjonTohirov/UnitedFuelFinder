//
//  NetResRefreshToken.swift
//  UnitedFuelFinder
//
//  Created by applebro on 28/10/23.
//

import Foundation

struct NetResRefreshToken: NetResBody {
    let accessToken: String
    let expiresIn: Double
    let refreshToken: String
    let tokenType: String
    let notBeforePolicy: Int
    let sessionState: String
    let scope: String
    
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
