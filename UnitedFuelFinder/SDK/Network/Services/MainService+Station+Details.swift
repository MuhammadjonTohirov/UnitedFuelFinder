//
//  MainService+Station+Details.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainService {
    func feedbacksFor(station id: Int) async -> [StationCommentItem] {
        let result: NetRes<[NetResStationComment]>? = await Network.send(request: MainNetworkRouter.feedbacksFor(station: id))
        
        return result?.data?.map({$0.asModel}) ?? []
    }
    
    func postFeedbackFor(station id: Int, rate: Int, comment: String) async -> Bool {
        let result: NetRes<String>? = await Network.send(request: MainNetworkRouter.postFeedback(station: id, request: .init(rate: rate, comment: comment)))

        return result?.success ?? false
    }
    
    func deleteFeedback(id: Int) async -> Bool {
        let result: NetRes<String>? = await Network.send(request: MainNetworkRouter.deleteFeedback(feedback: id))

        return result?.success ?? false
    }
}
