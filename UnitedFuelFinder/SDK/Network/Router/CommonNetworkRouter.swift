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
            return URL.baseAPI.appendingPath("Driver", "TotalSpends").queries(
                .init(name: "type", value: "\(type)")
            )
        case .cardInfo:
            return URL.baseAPI.appendingPath("Driver", "MainCard")
        case .popularStations(let size):
            return URL.baseAPI.appendingPath("Driver", "PopularStations").queries(
                .init(name: "size", value: "\(size)")
            )
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
        case .filterTransactions, .filterInvoices, .totalSpendings, .cardInfo, .popularStations:
            request = URLRequest.new(url: url)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        
        return request!
    }
    
    case states
    case cities(id: String)
    case companies
    case version
    case filterTransactions(fromDate: String, to: String)
    case filterInvoices(fromDate: String, to: String)
    
    /// 0: Today, 1: Week, 2: Month
    case totalSpendings(type: Int)
    
    case cardInfo
    case popularStations(amount: Int)
}
