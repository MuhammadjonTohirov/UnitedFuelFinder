//
//  CommonService.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation

public struct CommonService {
    public static let shared = CommonService()
    
    public func syncStates() async {
        let result: NetRes<[NetResState]>? = await Network.send(request: CommonNetworkRouter.states)
        
        let items = (result?.data ?? []).map({StateItem.init(res: $0)})
        MainDService.shared.addState(items)
    }
    
    public func syncCities(forState stateId: String) async {
        let result: NetRes<[NetResCity]>? = await Network.send(request: CommonNetworkRouter.cities(id: stateId))
        
        let items = (result?.data ?? []).map({CityItem(res: $0)})
        MainDService.shared.addCity(items)
    }
    
    public func syncCompanies() async {
        let result: NetRes<[NetResCompany]>? = await Network.send(request: CommonNetworkRouter.companies)
        let items = (result?.data ?? []).map({CompanyItem(res: $0)})
        
        MainDService.shared.addCompanies(items)
    }
    
    public func getVersion() async -> ServerVersion? {
        let result: NetRes<ServerVersion>? = await Network.send(request: CommonNetworkRouter.version)
        return result?.data
    }
    
    public func fetchTransactions(fromDate: String, to: String) async -> [NetResTransactions] {
        let result: NetRes<[NetResTransactions]>? = await Network.send(request: CommonNetworkRouter.filterTransactions(fromDate: fromDate, to: to))
        return result?.data ?? []
    }
}
