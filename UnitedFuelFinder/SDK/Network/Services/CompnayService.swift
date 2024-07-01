//
//  CompnayService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/06/24.
//

import Foundation

public struct CompanyService {
    public static let shared = CompanyService()
    
    public func loadDrivers(search: String? = nil) async -> [UserInfo] {
        let result: NetRes<[NetResUserInfo]>? = await Network.send(request: CompanyNetworkRouter.driverList(search: search))
        let userInfoList = result?.data?.map({$0.asModel}) ?? []
        return userInfoList
    }
    
    public func saveDriverSettings(id: String, req: NetReqSaveDriverSettings) async -> (success: Bool, error: String?) {
        let result: NetRes<String>? = await Network.send(request: CompanyNetworkRouter.saveDriverSettings(id: id, request: req))
        return (result?.success ?? false, result?.error)
    }
    
    public func loadDriverCards() async -> [DriverCard] {
        let result: NetRes<[NetResDriverCard]>? = await Network.send(request: CompanyNetworkRouter.driverCardList)
        return result?.data?.map { .init(res: $0) } ?? []
    }
}
