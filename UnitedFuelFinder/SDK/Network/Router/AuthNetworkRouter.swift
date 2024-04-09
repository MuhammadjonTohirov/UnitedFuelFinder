//
//  AuthNetworkRouter.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

enum UserNetworkRouter: URLRequestProtocol {
    var url: URL {
        switch self {
        case .verifyAccount:
            return URL.baseAPI.appendingPath("Account", "DriverVerify")
        case .login:
            return URL.baseAPI.appendingPath("Account", "ClientLogin")
        case .register:
            return URL.baseAPI.appendingPath("Account", "ClientRegister")
        case .refresh(let refreshToken):
            return URL.baseAPI.appendingPath("Account", "RefreshToken").queries(.init(name: "token", value: refreshToken))
        case .userInfo:
            return URL.baseAPI.appendingPath("Driver", "UserInfo")
        case .editUserInfo:
            return URL.baseAPI.appendingPath("Driver", "UpdateProfile")
        case .deleteProfile:
            return URL.baseAPI.appendingPath("Driver", "DeleteAccount")
        case .confirmDeleteProfile:
            return URL.baseAPI.appendingPath("Driver", "ConfirmDelete")
        case .forgotPassword:
            return URL.baseAPI.appendingPath("Account", "ResetPassword")
        case .changePassword:
            return URL.baseAPI.appendingPath("Driver", "ChangePassword")
        }
    }
    
    var body: Data? {
        switch self {
        case .verifyAccount(let request):
            return request.asData
        case .login(let request):
            return request.asData
        case .register(let request):
            return request.asData
        case .editUserInfo(let request):
            return request.asData
        case .confirmDeleteProfile(let request):
            return request.asData
        case .changePassword(let request):
            return request.asData
        case .forgotPassword(let request):
            return request.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .userInfo:
            return .get
        case .editUserInfo:
            return .put
        case .deleteProfile:
            return .delete
        default:
            return .post
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .verifyAccount, .login, .register, .refresh:
            request = URLRequest.new(url: url, withAuth: false)
            request?.httpBody = self.body
        default:
            request = URLRequest.new(url: url, withAuth: true)
            request?.httpBody = self.body
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }
    
    case verifyAccount(request: NetReqVerifyAccount)
    case login(request: NetReqLogin)
    case register(request: NetReqRegister)
    case refresh(refreshToken: String)
    case forgotPassword(request: NetReqForgotPassword)
    case changePassword(request: NetReqChangePassword)
    case userInfo
    case editUserInfo(request: NetReqEditProfile)
    case deleteProfile
    case confirmDeleteProfile(request: NetReqDeleteConfirm)
}
