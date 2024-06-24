//
//  MainNetworkRounter+URL.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainNetworkRouter {
    var url: URL {
        switch self {
        case .stationsInCity(let cityId):
            return URL.baseAPI.appendingPath("Driver", "Stations", cityId)
        case .filterStations:
            return URL.baseAPI.appendingPath("Driver", "FilterStations")
        case .filterStations2:
            return URL.baseAPI.appendingPath("Driver", "FilterStationsV2")
        case .filterStations3:
            return URL.init(
                string: "http://15.235.212.129:50000/api/Driver/MultipleStationsFilter"
            )!
        case .feedbacksFor(let stationId):
            return URL.baseAPI.appendingPath("Driver", "StationFeedbacks", stationId)
        case .postFeedback(let stationId, _):
            return URL.baseAPI.appendingPath("Driver", "PostFeedback", stationId)
        case .deleteFeedback(let feedback):
            return URL.baseAPI.appendingPath("Driver", "DeleteFeedback", feedback)
        case .discountedStations(_, let limit):
            return URL.baseAPI.appendingPath("Driver", "DiscountedStations").queries(.init(name: "limit", value: "\(limit)"))
        case .getSessions:
            return URL.baseAPI.appendingPath("Driver", "DeviceSessions")
        case .getAuditLogs:
            return URL.baseAPI.appendingPath("Driver", "AuditLogs")
        case .getCustomers:
            return URL.baseAPI.appendingPath("Driver", "Customers")
        case .searchAddresses(let text):
            return URL.baseAPI.appendingPath("Driver", "SearchLocations").queries(.init(name: "term", value: text))
        case .uploadAvatar:
            return URL.baseAPI.appendingPath("Driver", "UploadAvatar")
        case .allStations:
            return URL.baseAPI.appendingPath("Driver", "AllStations")
        }
    }
}
