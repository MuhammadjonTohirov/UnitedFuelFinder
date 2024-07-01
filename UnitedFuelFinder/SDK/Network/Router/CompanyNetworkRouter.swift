//
//  CompanyNetworkRouter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/06/24.
//

import Foundation

enum CompanyNetworkRouter: URLRequestProtocol {
    case driverList(search: String? = nil)
    case saveDriverSettings(
        id: String,
        request: NetReqSaveDriverSettings
    )
    case driverCardList
    
    var url: URL {
        switch self {
        case .driverList(let search):
            return URL.baseAPI.appendingPath("Company", "Drivers").queries(
                .init(name: "searchTerm", value: search ?? " ")
            )
        case .saveDriverSettings(let id, _):
            return URL.baseAPI.appendingPath("Company", "DriverSettings", id)
        case .driverCardList:
            return URL.baseAPI.appendingPath("Company", "DriverCards")
        }
    }
    
    var body: Data? {
        switch self {
        case .saveDriverSettings(_, let request):
            return request.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .saveDriverSettings:
            return .post
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request = URLRequest.new(url: url)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = body
        request.httpMethod = method.rawValue
        return request
    }
}
