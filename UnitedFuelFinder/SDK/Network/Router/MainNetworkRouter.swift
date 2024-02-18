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
        }
    }
    
    var body: Data? {
        switch self {
        case .filterStations(let request), .discountedStations(let request, _):
            return request.asData
        case .postFeedback(_, let request):
            return request.asData
        case .uploadAvatar(let photoUrl):
            return autoreleasepool {
                guard let data = try? Data.init(contentsOf: photoUrl) else {
                    return nil
                }
                let form = MultipartForm(
                    parts: [
                        .init(
                            name: "File",
                            data: data,
                            filename: photoUrl.lastPathComponent,
                            contentType: photoUrl.mimeType
                        ),
                    ],
                    boundary: "Boundary-\(photoUrl.lastPathComponent)")
                return form.bodyData
            }
        default:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .filterStations, .postFeedback, .discountedStations, .uploadAvatar:
            return .post
        case .deleteFeedback:
            return .delete
        default:
            return .get
        }
    }
    
    func request() -> URLRequest {
        if case .uploadAvatar(let url) = self {
            var request = URLRequest.fromDataRequest(url: self.url, boundary: "Boundary-\(url.lastPathComponent)")
            request.httpMethod = method.rawValue.uppercased()
            return request
        }
        var request: URLRequest = URLRequest.new(url: url, withAuth: true)
        request.httpMethod = method.rawValue.uppercased()
        request.httpBody = self.body
        return request
    }
    
    case stationsInCity(_ cityId: String)
    case filterStations(request: NetReqFilterStations)
    case discountedStations(request: NetReqFilterStations, limit: Int)
    case feedbacksFor(station: Int)
    case postFeedback(station: Int, request: NetReqStationFeedback)
    case deleteFeedback(feedback: Int)
    case getSessions
    case getAuditLogs
    case getCustomers
    case searchAddresses(text: String)
    case uploadAvatar(imageUrl: URL)
}
