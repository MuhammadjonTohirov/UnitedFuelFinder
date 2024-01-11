//
//  CommonNetworkRouter.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation

enum CommonNetworkRouter: URLRequestProtocol {
    var url: URL {
        switch self {
        case .states:
            return URL.baseAPI.appendingPath("Common", "States")
        case .cities(let id):
            return URL.baseAPI.appendingPath("Common", "Cities").queries(.init(name: "state", value: id))
        case .companies:
            return URL.baseAPI.appendingPath("Common", "Companies")
        case .version:
            return URL.baseAPI.appendingPath("Common", "Version")
        }
    }
    
    var body: Data? {
        nil
    }
    
    var method: HTTPMethod {
        .get
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .states, .cities, .companies, .version:
            request = URLRequest.new(url: url, withAuth: false)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }
    
    case states
    case cities(id: String)
    case companies
    case version
}
