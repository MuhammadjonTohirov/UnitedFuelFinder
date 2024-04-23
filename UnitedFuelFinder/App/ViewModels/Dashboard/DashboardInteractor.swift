//
//  DashboardInteractor.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

protocol DashboardInteractorProtocol {
    func getTransactions(from: Date, to: Date) async -> [TransactionItem]
    
    func getInvoices(from: Date, to: Date) async -> [InvoiceItem]
    
    func loadCustomers() async
}

class DashboardInteractor: DashboardInteractorProtocol {
    /// fromdate -  ddMMyyyy
    func getTransactions(from: Date, to: Date) async -> [TransactionItem] {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        return (await CommonService.shared.fetchTransactions(
            fromDate: _from,
            to: _to
        )).compactMap({TransactionItem(from: $0)})
    }
    
    func getInvoices(from: Date, to: Date) async -> [InvoiceItem] {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        return (await CommonService.shared.fetchInvoices(
            fromDate: _from,
            to: _to
        )).compactMap({InvoiceItem(from: $0)})
    }
    
    func loadCustomers() async {
        _ = await MainService.shared.syncCustomers()
    }
    func getVersion() async{
//        if let serverVersion = await CommonService.shared.getVersion() {
//            UserSettings.shared.currentAPIVersion = serverVersion
//        }
    }
}

class DashboardTestInteractor: DashboardInteractorProtocol {
    func getTransactions(from: Date, to: Date) async -> [TransactionItem] {
        []
    }
    
    func getInvoices(from: Date, to: Date) async -> [InvoiceItem] {
        []
    }
    
    func loadCustomers() async {
        
    }
}
