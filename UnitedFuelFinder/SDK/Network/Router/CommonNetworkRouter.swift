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
        case .actualAppVersion:
            return URL.baseAPI.appendingPath("Common", "Config")
            
        case let .filterTransactions(fromDate, to):
            return URL.baseAPI.appendingPath("Driver", "FilterTransactions").queries(
                .init(name: "fromDate", value: fromDate),
                .init(name: "toDate", value: to)
            )
        case let .filterInvoices(fromDate, to):
            return URL.baseAPI.appendingPath("Driver", "FilterInvoices").queries(
                .init(name: "fromDate", value: fromDate),
                .init(name: "toDate", value: to)
            )
        case let .totalSpendings(type):
            return URL.baseAPI.appendingPath("Driver", "TotalSpendsV2").queries(
                .init(name: "type", value: "\(type)")
            )
        case .cardInfo:
            return URL.baseAPI.appendingPath("Driver", "MainCard")
        case .popularStations(let size):
            return URL.baseAPI.appendingPath("Driver", "PopularStations").queries(
                .init(name: "size", value: "\(size)")
            )
        case .findRoute:
            return URL.baseAPI.appendingPath("Driver", "DrawRoutes")
        case .findMultipleRoute:
            return URL.baseAPI.appendingPath("Driver", "DrawMultipleRoutes")
        }
    }
    
    var body: Data? {
        switch self {
        case .findRoute(let req):
            return req.asData
        case .findMultipleRoute(let req):
            return req.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .findRoute, .findMultipleRoute:
            return .post
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        case .states, .cities, .companies, .version, .actualAppVersion:
            request = URLRequest.new(url: url, withAuth: false)
        default:
            request = URLRequest.new(url: url)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        request?.httpBody = body
        return request!
    }
    
    case states
    case cities(id: String)
    case companies
    case version
    case filterTransactions(fromDate: String, to: String)
    case filterInvoices(fromDate: String, to: String)
    case findRoute(req: NetReqDrawRoute)
    /// 0: Today, 1: Week, 2: Month
    case totalSpendings(type: Int)
    
    case cardInfo
    case popularStations(amount: Int)
    case actualAppVersion
    case findMultipleRoute(request: NetReqDrawMultipleRoute)
}
