//
//  MainService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation
import RealmSwift

struct MainService {
    static let shared = MainService()
    
    func findStations(atCity cityId: String) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.stationsInCity(cityId))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(atLocation location: (lat: Double, lng: Double), in distance: Int) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(
                current: .init(
                    lat: location.lat,
                    lng: location.lng
                ),
                distance: Double(distance)
            )
        ))
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
    
    func filterStations(from location: (lat: Double, lng: Double), to toLocation: (lat: Double, lng: Double), in distance: Double = 10) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(
            request: .init(
                from: .init(lat: location.lat, lng: location.lng),
                to: .init(lat: toLocation.lat, lng: toLocation.lng), 
                distance: distance
            ))
        )
        
        let items: [StationItem] = ((result?.data) ?? []).compactMap({.init(res: $0)})
        return items
    }
    
    func filterStations(req: NetReqFilterStations) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations(request: req))
        
        let items: [StationItem] = ((result?.data) ?? []).compactMap({.init(res: $0)})
        return items
    }

    func filterStations2(req: NetReqFilterStations) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.filterStations2(request: req)
        )
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }

    func discountedStations(atLocation location: (lat: Double, lng: Double), in distance: Int, limit: Int = 8) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.discountedStations(
            request: .init(current: .init(lat: location.lat, lng: location.lng), distance: Double(distance)), limit: limit)
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
    
    func getSessions() async -> [SessionItem] {
        let result: NetRes<[NetResSessionItem]>? = await Network.send(request: MainNetworkRouter.getSessions)
        
        return ((result?.data) ?? []).compactMap({.init($0)})
    }
    
    func getAuditLogs() async -> [AuditLog] {
        let result: NetRes<[NetResAuditLog]>? = await Network.send(request: MainNetworkRouter.getAuditLogs)
        return ((result?.data) ?? []).compactMap({.init($0)})
    }
    
    func getCustomers() async -> [CustomerItem] {
        let result: NetRes<[NetResCustomerItem]>? = await Network.send(request: MainNetworkRouter.getCustomers)
        let customers = ((result?.data)?.map({CustomerItem.create(from: $0)})) ?? []
        DCustomer.addAll(customers)
        try? await Task.sleep(for: .seconds(1))
        return customers
    }
    
    func searchAddresses(_ query: String) async -> [NetResSearchAddressItem] {
        let result: NetRes<[NetResSearchAddressItem]>? = await Network.send(request: MainNetworkRouter.searchAddresses(text: query))
        return result?.data ?? []
    }
    
    func uploadAvatar(_ image: URL, completion: @escaping (Bool) -> Void) {
        Network.upload(
            body: String.self,
            request: MainNetworkRouter.uploadAvatar(imageUrl: image)) { result in
                completion(result?.success ?? false)
            }
    }
}
