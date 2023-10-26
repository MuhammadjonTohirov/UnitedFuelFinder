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
            UserSettings.shared.session = data.session
            UserSettings.shared.lastOTP = data.code
            return (data.exists, data.code, data.session)
        }
        
        return nil
    }
    
    public func login(session: String, code: String, username: String) async -> Bool {
        guard let result: NetRes<NetResLogin> = await Network.send(request: UserNetworkRouter.login(request: .init(email: username, confirm: .init(code: code, session: session)))),
                let data = result.data else {
            return false
        }
        
        UserSettings.shared.accessToken = data.accessToken
        UserSettings.shared.refreshToken = data.refreshToken
        UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
        
        return result.data != nil
    }
    
    public func register(with request: NetReqRegister) async -> Bool {
        let result: NetRes<String>? = await Network.send(request: UserNetworkRouter.register(request: request))
        
        return result?.success ?? false
    }
    
    public func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }
    
}
