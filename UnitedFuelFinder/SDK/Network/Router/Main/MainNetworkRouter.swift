//
//  MainNetworkRouter.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

enum MainNetworkRouter: URLRequestProtocol {    
    case stationsInCity(_ cityId: String)
    case filterStations(request: NetReqFilterStations)
    case filterStations2(request: NetReqFilterStations)
    case discountedStations(request: NetReqFilterStations, limit: Int)
    case feedbacksFor(station: Int)
    case postFeedback(station: Int, request: NetReqStationFeedback)
    case deleteFeedback(feedback: Int)
    case getSessions
    case getAuditLogs
    case getCustomers
    case searchAddresses(text: String)
    case uploadAvatar(imageUrl: URL)
    case allStations
}
