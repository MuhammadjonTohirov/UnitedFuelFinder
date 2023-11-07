//
//  AuthService.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

enum AuthNetworkErrorReason: Error {
    case notConfirmedByAdmin
    case userAlreadyExists
    case unknown
    case custom(String)
}

public struct AuthService {
    public static let shared = AuthService()
    
    public func verifyAccount(_ username: String) async -> (exist: Bool, code: String, session: String)? {
        let result: NetRes<NetResVerifyAccount>? = await Network.send(request: UserNetworkRouter.verifyAccount(request: .init(email: username)))
        
        if let data = result?.data {
            UserSettings.shared.session = data.session
            UserSettings.shared.lastOTP = data.code
            UserSettings.shared.userEmail = username
            return (data.exists, data.code, data.session)
        }
        
        return nil
    }
    
    func login(session: String, code: String, username: String) async -> (Bool, AuthNetworkErrorReason?) {
        guard let result: NetRes<NetResLogin> = await Network.send(request: UserNetworkRouter.login(request: .init(email: username, confirm: .init(code: code, session: session)))) else {
            return (false, .unknown)
        }
        
        guard let data = result.data else {
            return (false, .notConfirmedByAdmin)
        }
        
        UserSettings.shared.accessToken = data.accessToken
        UserSettings.shared.refreshToken = data.refreshToken
        UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
        let isOK = result.data != nil
        return (isOK, isOK ? nil : (result.code == 400 ? .notConfirmedByAdmin : .unknown))
    }
    
    func register(with request: NetReqRegister) async -> (Bool, AuthNetworkErrorReason?) {
        let result: NetRes<String>? = await Network.send(request: UserNetworkRouter.register(request: request))
        
        
        return (result?.success ?? false, result?.error?.nilIfEmpty == nil ? nil : .custom(result?.error ?? "") )
    }
    
    func refreshToken() async -> Bool {
        guard let token = UserSettings.shared.refreshToken else {
            return false
        }
        
        let result: NetRes<NetResRefreshToken>? = await Network.send(request: UserNetworkRouter.refresh(refreshToken: token))
        
        if let data = result?.data {
            UserSettings.shared.accessToken = data.accessToken
            UserSettings.shared.refreshToken = data.refreshToken
            UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
            return true
        }
        
        return false
    }
    
    public func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }
    
    func syncUserInfo() async {
        let response: NetRes<NetResUserInfo>? = await Network.send(request: UserNetworkRouter.userInfo)
        UserSettings.shared.userInfo = response?.data?.asModel
    }
    
    func editUserInfo(firstName: String, lastName: String, phone: String, state: String, city: Int, address: String) async -> Bool {
        let req = NetReqEditProfile.init(firstName: firstName, lastName: lastName, phone: phone, state: state, city: city, address: address)
        let result: NetRes<String>? = await Network.send(request: UserNetworkRouter.editUserInfo(request: req))
        let isOK = result?.success ?? false
        
        if isOK, let user = UserSettings.shared.userInfo, let _city = DCity.item(id: city) {
            
            let _user = UserInfo.init(id: user.id, fullName: [firstName, lastName].joined(separator: " "),
                          email: user.email,
                          phone: user.phone,
                          cardNumber: user.cardNumber,
                          companyId: user.companyId, companyName: user.companyName,
                          address: address, cityId: city, cityName: _city.name, state: state, confirmed: true, deleted: false)
            UserSettings.shared.userInfo = _user
        }
        
        return isOK
    }
}

extension NetResUserInfo {
    var asModel: UserInfo {
        .init(res: self)
    }
}
