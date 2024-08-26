//
//  AuthService.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

public enum AuthNetworkErrorReason: Error {
    //case notConfirmedByAdmin
    //case userAlreadyExists
    case unknown
    case custom(String)
    
    var localizedDescription: String {
        switch self {
        case .unknown:
            return "unknown_error".localize
            
        case .custom(let message):
            return message
        }
    }
}

public struct AuthService {
    public static let shared = AuthService()
    
    public func verifyAccount(_ email: String) async -> (Bool, error: AuthNetworkErrorReason?) {
        guard let result: NetRes<NetResLogin> = await Network.send(
            request: UserNetworkRouter.verifyAccount(email: email),
            refreshTokenIfNeeded: false
        ) else {
            return (false, .unknown)
        }
        
        if !result.success && result.error?.contains("expire") ?? false {
            return (false, .custom(result.error ?? "Unknown error"))
        }
        
        guard let data = result.data else {
            //return (false, .notConfirmedByAdmin)
            return (false, .custom(result.error ?? "Unknown error"))
        }
        
        UserSettings.shared.accessToken = data.accessToken
        UserSettings.shared.refreshToken = data.refreshToken
        UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
        UserSettings.shared.refreshTokenExpireDate = .init(timeIntervalSinceNow: data.refreshExpiresIn)
        UserSettings.shared.userEmail = email
        
        await syncUserInfo()
        
        let isOK = result.data != nil
        return (isOK, isOK ? nil : .custom(result.error ?? "Unknown error"))
    }
    
    func login(username: String, password: String) async -> (Bool, AuthNetworkErrorReason?) {
        guard let result: NetRes<NetResLogin> = await Network.send(
            request: UserNetworkRouter.login(
                request: .init(
                    email: username,
                    password: password
                )
            ),
            refreshTokenIfNeeded: false
        ) else {
            return (false, .custom("Unknown error"))
        }
        
        if !result.success && result.error?.contains("expire") ?? false {
            return (false, .custom(result.error ?? "Unknown error"))
        }
        
        guard let data = result.data else {
            //return (false, .notConfirmedByAdmin)
            return (false, .custom(result.error ?? "Unknown error"))
        }
        
        UserSettings.shared.accessToken = data.accessToken
        UserSettings.shared.refreshToken = data.refreshToken
        UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
        UserSettings.shared.refreshTokenExpireDate = .init(timeIntervalSinceNow: data.refreshExpiresIn)
        UserSettings.shared.userEmail = username
        
        await syncUserInfo()
        
        let isOK = result.data != nil
        return (isOK, isOK ? nil : .custom(result.error ?? "Unknown error"))
    }
    
    func register(with request: NetReqRegister) async -> (Bool, AuthNetworkErrorReason?) {
        let result: NetRes<String>? = await Network.send(
            request: UserNetworkRouter.register(request: request),
            refreshTokenIfNeeded: false
        )
        
        return (result?.success ?? false, result?.error?.nilIfEmpty == nil ? nil : .custom(result?.error ?? "") )
    }
    
    func refreshTokenIfRequired() async -> Bool {
        if (UserSettings.shared.tokenExpireDate?.timeIntervalSinceNow ?? 0) < 10 {
            return await refreshToken()
        }
        // no need for refresh token
        return true
    }
    
    func refreshToken() async -> Bool {
        guard let token = UserSettings.shared.refreshToken else {
            return false
        }
        let isRefreshExpired = (UserSettings.shared.refreshTokenExpireDate?.timeIntervalSinceNow ?? 0) < 10
        if isRefreshExpired{
            return false
        }
        let result: NetRes<NetResRefreshToken>? = await Network.send(request: UserNetworkRouter.refresh(refreshToken: token), refreshTokenIfNeeded: false)
        
        if let data = result?.data {
            UserSettings.shared.accessToken = data.accessToken
            UserSettings.shared.refreshToken = data.refreshToken
            UserSettings.shared.tokenExpireDate = .init(timeIntervalSinceNow: data.expiresIn)
            UserSettings.shared.refreshTokenExpireDate = .init(timeIntervalSinceNow: data.refreshExpiresIn)
            return true
        }
        
        Logging.l("Unable to refresh token")
        return false
    }
    
    public func confirm(otp: String) async -> Bool {
        sleep(1)
        return otp == UserSettings.shared.lastOTP
    }
    
    @discardableResult
    func syncUserInfo() async -> Bool {
        let response: NetRes<NetResUserInfo>? = await Network.send(request: UserNetworkRouter.userInfo)
        UserSettings.shared.userInfo = response?.data?.asModel
        UserSettings.shared.userType = (response?.data?.asModel.roleCode.lowercased().contains("driver") ?? true) ? .driver : .company
        Logging.l("User sync \(response?.data != nil)")
        return response?.data != nil
    }
    
    func editUserInfo(firstName: String, lastName: String, phone: String, state: String? = nil, city: Int? = nil, address: String? = nil, company: String, cardNumber: String) async -> Bool {
        let req = NetReqEditProfile(
            firstName: firstName,
            lastName: lastName,
            phone: phone,
            state: state,
            city: city,
            address: address,
            cardNumber: cardNumber,
            companyName: company
        )
        
        let result: NetRes<String>? = await Network.send(request: UserNetworkRouter.editUserInfo(request: req))
        let isOK = result?.success ?? false
        
        if isOK {
            var info = UserSettings.shared.userInfo
            info?.firstName = firstName
            info?.lastName = lastName
            info?.phone = phone
            info?.stateId = state
            info?.cityId = city
            info?.address = address
            UserSettings.shared.userInfo = info
        }
        
        return isOK
    }
    
    func deleteProfileRequest() async -> Bool {
        let response: NetRes<NetResDelete>? = await Network.send(request: UserNetworkRouter.deleteProfile)
        
        if let data = response?.data {
            UserSettings.shared.session = data.session
            return true
        }
        
        return false
    }
    
    func confirmDeleteProfile(session: String, code: String) async -> Bool {
        let response: NetRes<String>? = await Network.send(request: UserNetworkRouter.confirmDeleteProfile(request: .init(code: code, session: session)))
        return response?.success ?? false
    }
    
    func forgotPassword(email: String) async -> Bool {
        let request = NetReqForgotPassword(email: email)
        
        let response: NetRes<String>? = await Network.send(
            request: UserNetworkRouter.forgotPassword(request: request),
            refreshTokenIfNeeded: false
        )
        return response?.success ?? false
    }
    
    func changePassword(confirmPassword: String, oldPassword: String, newPassword: String) async -> Bool {
        let request = NetReqChangePassword(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: confirmPassword
        )
        
        let response: NetRes<String>? = await Network.send(
            request: UserNetworkRouter.changePassword(request: request)
        )
        return response?.success ?? false
    }
}

extension NetResUserInfo {
    var asModel: UserInfo {
        .init(res: self)
    }
}
