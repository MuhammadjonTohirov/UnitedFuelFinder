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
        case .feedbacksFor(let stationId):
            return URL.baseAPI.appendingPath("Driver", "StationFeedbacks", stationId)
        case .postFeedback(let stationId, _):
            return URL.baseAPI.appendingPath("Driver", "PostFeedback", stationId)
        case .deleteFeedback(let feedback):
            return URL.baseAPI.appendingPath("Driver", "DeleteFeedback", feedback)
        }
    }
    
    var body: Data? {
        switch self {
        case .filterStations(let request):
            return request.asData
        case .postFeedback(_, let request):
            return request.asData
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .filterStations, .postFeedback:
            return .post
        case .deleteFeedback:
            return .delete
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        var request: URLRequest?
        
        switch self {
        default:
            request = URLRequest.new(url: url, withAuth: true)
        }
        
        request?.httpMethod = method.rawValue.uppercased()
        request?.httpBody = self.body
        return request!
    }
    
    case stationsInCity(_ cityId: String)
    case filterStations(request: NetReqFilterStations)
    case feedbacksFor(station: Int)
    case postFeedback(station: Int, request: NetReqStationFeedback)
    case deleteFeedback(feedback: Int)
}
