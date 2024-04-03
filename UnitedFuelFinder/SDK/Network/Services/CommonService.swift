//
//  CommonService.swift
//  USDK
//
//  Created by applebro on 26/10/23.
//

import Foundation

public actor CommonService {
    public static let shared = CommonService()
    
    public func syncStates() async {
        let result: NetRes<[NetResState]>? = await Network.send(request: CommonNetworkRouter.states, refreshTokenIfNeeded: false)
        
        let items = (result?.data ?? []).map({StateItem.init(res: $0)})
        await MainDService.shared.addState(items)
    }
    
    public func syncCities(forState stateId: String) async {
        let result: NetRes<[NetResCity]>? = await Network.send(request: CommonNetworkRouter.cities(id: stateId), refreshTokenIfNeeded: false)
        
        let items = (result?.data ?? []).map({CityItem(res: $0)})
        
        await MainDService.shared.addCity(items)
    }
    
    public func syncCompanies() async {
        let result: NetRes<[NetResCompany]>? = await Network.send(request: CommonNetworkRouter.companies, refreshTokenIfNeeded: false)
        let items = (result?.data ?? []).map({CompanyItem(res: $0)})
        
        await MainDService.shared.addCompanies(items)
    }
    
    public func getVersion() async -> ServerVersion? {
        let result: NetRes<ServerVersion>? = await Network.send(request: CommonNetworkRouter.version, refreshTokenIfNeeded: false)
        return result?.data
    }
    
    public func fetchTransactions(fromDate: String, to: String) async -> [NetResTransactions] {
        let result: NetRes<[NetResTransactions]>? = await Network.send(request: CommonNetworkRouter.filterTransactions(fromDate: fromDate, to: to))
        return result?.data ?? []
    }

    public func fetchInvoices(fromDate: String, to: String) async -> [NetResInvoiceItem] {
        let result: NetRes<[NetResInvoiceItem]>? = await Network.send(request: CommonNetworkRouter.filterInvoices(fromDate: fromDate, to: to))
        return result?.data ?? []
    }
    
    public func fetchTotalSpending(type: Int) async -> NetResTotalSpending {
        let result: NetRes<NetResTotalSpending>? = await Network.send(request: CommonNetworkRouter.totalSpendings(type: type))
        return result?.data ?? NetResTotalSpending(total: 0, records: [])
    }
    
    public func fetchCardInfo() async -> NetResCard? {
        let result: NetRes<NetResCard>? = await Network.send(request: CommonNetworkRouter.cardInfo)
        return result?.data
    }
    
    public func fetchPopularStations(size: Int = 3) async -> NetResPopularStations? {
        let result: NetRes<NetResPopularStations>? = await Network.send(request: CommonNetworkRouter.popularStations(amount: size))
        return result?.data
    }
}
