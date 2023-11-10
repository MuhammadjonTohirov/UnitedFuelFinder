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
        case .filterStations:
            return URL.baseAPI.appendingPath("Driver", "FilterStations")
        }
    }
    
    var body: Data? {
        switch self {
        case .filterStations(let request):
            return request.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .filterStations:
            return .post
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .stationsInCity, .filterStations:
            request = URLRequest.new(url: url, withAuth: true)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        request?.httpBody = self.body
        return request!
    }
    
    case stationsInCity(_ cityId: String)
    case filterStations(request: NetReqFilterStations)
}
