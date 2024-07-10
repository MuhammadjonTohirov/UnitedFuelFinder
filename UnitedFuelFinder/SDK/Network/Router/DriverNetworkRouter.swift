//
//  DriverNetworkRouter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/07/24.
//

import Foundation

enum DriverNetworkRouter: URLRequestProtocol {
    case totalSavings
    case totalGallons
    case meanDiscount
    case companySummarySpends(type: Int)
    case driverSummarySpends(type: Int)
    
    var url: URL {
        switch self {
        case .meanDiscount:
            return URL.baseAPI.appendingPath("Driver", "AvgDiscount")
        case .totalSavings:
            return URL.baseAPI.appendingPath("Driver", "TotalSavings")
        case .totalGallons:
            return URL.baseAPI.appendingPath("Driver", "TotalGallons")
        case .driverSummarySpends(let type):
            return URL.baseAPI.appendingPath("Driver", "SummarySpends")
                .queries(.init(name: "type", value: "\(type)"))
        case .companySummarySpends(let type):
            return URL.baseAPI.appendingPath("Company", "SummarySpends")
                .queries(.init(name: "type", value: "\(type)"))
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
        var request: URLRequest = URLRequest.new(url: url, withAuth: true)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = body
        return request
    }
}
