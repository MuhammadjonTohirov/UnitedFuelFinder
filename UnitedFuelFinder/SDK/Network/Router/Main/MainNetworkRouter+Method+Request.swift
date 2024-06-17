//
//  MainNetworkRouter+Method+Request.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainNetworkRouter {
    var method: HTTPMethod {
        switch self {
        case .filterStations, .filterStations2, .filterStations3, .postFeedback, .discountedStations, .uploadAvatar:
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
}
