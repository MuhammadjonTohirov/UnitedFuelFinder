//
//  MainService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 29/10/23.
//

import Foundation
import RealmSwift

actor MainService {
    static let shared = MainService()

    func discountedStations(atLocation location: (lat: Double, lng: Double), in distance: Int, limit: Int = 8) async -> [StationItem] {
        let result: NetRes<[NetResStationItem]>? = await Network.send(request: MainNetworkRouter.discountedStations(
            request: .init(current: .init(lat: location.lat, lng: location.lng), distance: Double(distance)), limit: limit)
        )
        
        return ((result?.data) ?? []).compactMap({.init(res: $0)})
    }
        
    func getSessions() async -> [SessionItem] {
        let result: NetRes<[NetResSessionItem]>? = await Network.send(request: MainNetworkRouter.getSessions)
        
        return ((result?.data) ?? []).compactMap({.init($0)})
    }
    
    func getAuditLogs() async -> [AuditLog] {
        let result: NetRes<[NetResAuditLog]>? = await Network.send(request: MainNetworkRouter.getAuditLogs)
        return ((result?.data) ?? []).compactMap({.init($0)})
    }
    
    @discardableResult
    func syncCustomers() async -> [CustomerItem] {
        let result: NetRes<[NetResCustomerItem]>? = await Network.send(request: MainNetworkRouter.getCustomers)
        let customers = ((result?.data)?.map({CustomerItem.create(from: $0)})) ?? []
        await MainDService.shared.removeAllCustomers()
        await MainDService.shared.addCustomers(customers)
        ShortStorage.default.customers = result?.data
        return customers
    }
    
    func searchAddresses(_ query: String) async -> [NetResSearchAddressItem] {
        let result: NetRes<[NetResSearchAddressItem]>? = await Network.send(request: MainNetworkRouter.searchAddresses(text: query))
        return result?.data ?? []
    }
}
