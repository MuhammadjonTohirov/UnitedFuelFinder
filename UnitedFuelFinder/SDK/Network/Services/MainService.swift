//
//  MainService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation

struct MainService {
    static let shared = MainService()
    
    func findStations(atCity cityId: String) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.stationsInCity(cityId))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(atLocation location: (lat: Double, lng: Double), in distance: Double) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(current: .init(lat: location.lat, lng: location.lng), distance: distance))
        )
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func discountedStations(atLocation location: (lat: Double, lng: Double), in distance: Int) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.discountedStations(
            request: .init(current: .init(lat: location.lat, lng: location.lng), distance: Double(distance)))
        )
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
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
