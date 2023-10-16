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
            return URL.base.appendingPath("Account", "ClientVerify")
        case .login:
            return URL.base.appendingPath("Account", "ClientLogin")
        }
    }
    
    var body: Data? {
        switch self {
        case .verifyAccount(let request):
            return request.asData
        case .login(let request):
            return request.asData
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .verifyAccount, .login:
            return .post
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .verifyAccount:
            request = URLRequest.new(url: url, withAuth: false)
            request?.httpBody = self.body
        case .login:
            request = URLRequest.new(url: url, withAuth: false)
            request?.httpBody = self.body
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }
    
    case verifyAccount(request: NetReqVerifyAccount)
    case login(request: NetReqLogin)
    
    
}
