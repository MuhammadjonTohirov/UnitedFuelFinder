//
//  DriverService.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/07/24.
//

import Foundation

public struct DriverService {
    static let shared = DriverService()
    
    func totalSavings() async -> Float {
        let result: NetRes<Float>? = await Network.send(request: DriverNetworkRouter.totalSavings)
        return result?.data ?? 0
    }
    
    func totalGallons() async -> Float {
        let result: NetRes<Float>? = await Network.send(request: DriverNetworkRouter.totalGallons)
        return result?.data ?? 0
    }
    
    func meanDiscount() async -> Float {
        let result: NetRes<Float>? = await Network.send(request: DriverNetworkRouter.meanDiscount)
        return result?.data ?? 0
    }
    
    func summarySpending(type: Int) async -> (saving: Double, spending: Double, error: String?) {
        var req: any URLRequestProtocol = DriverNetworkRouter.companySummarySpends(type: type)
        
        if UserSettings.shared.userType == .driver {
            req = DriverNetworkRouter.driverSummarySpends(type: type)
        }
        
        let result: NetRes<NetResSummarySpend>? = await Network.send(request: req)
        return (result?.data?.savings ?? 0, result?.data?.spendings ?? 0, result?.error)
    }
}
