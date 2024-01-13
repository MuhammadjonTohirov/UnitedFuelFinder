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
            return URL.baseAPI.appendingPath("Account", "DriverLogin")
        case .register:
            return URL.baseAPI.appendingPath("Account", "DriverRegister")
        case .refresh(let refreshToken):
            return URL.baseAPI.appendingPath("Account", "RefreshToken").queries(.init(name: "token", value: refreshToken))
        case .userInfo:
            return URL.baseAPI.appendingPath("Driver", "UserInfo")
        case .editUserInfo:
            return URL.baseAPI.appendingPath("Driver", "UpdateProfile")
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
        case .userInfo, .editUserInfo:
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
    case userInfo
    case editUserInfo(request: NetReqEditProfile)
    case deleteProfile
}
