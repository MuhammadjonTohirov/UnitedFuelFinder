//
//  MainNetworkRouter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

enum MainNetworkRouter: URLRequestProtocol {
    var url: URL {
        switch self {
        case .stationsInCity(let cityId):
            return URL.baseAPI.appendingPath("Driver", "Stations", cityId)
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .stationsInCity:
            request = URLRequest.new(url: url, withAuth: true)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }
    
    case stationsInCity(_ cityId: String)
}
