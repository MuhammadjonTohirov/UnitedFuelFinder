//
//  AuthService.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

public struct AuthService {
    public static let shared = AuthService()
    
    public func verifyAccount(_ username: String) async -> (exist: Bool, code: String, session: String)? {
        let result: NetRes<NetResVerifyAccount>? = await Network.send(request: UserNetworkRouter.verifyAccount(request: .init(email: username)))
        
        if let data = result?.data {
            return (data.exists, data.code, data.session)
        }
        
        return nil
    }
    
    public func login(session: String, code: String, username: String) async -> Bool {
        let result: NetRes<NetResLogin>? = await Network.send(request: UserNetworkRouter.login(request: .init(email: username, confirm: .init(code: code, session: session))))
        
//        handle response for access and refresh token
        
        return result?.data != nil
    }
    
    public func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }
    
}
