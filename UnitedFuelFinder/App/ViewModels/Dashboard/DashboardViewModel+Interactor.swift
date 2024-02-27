//
//  DashboardViewModel+Interactor.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation

extension DashboardViewModel {
    func loadTransactions() async {
        let _transactions = await interactor.getTransactions(
            from: Date().before(monthes: 3),
            to: Date()
        )
     
        
        await MainActor.run {
            self.transactions = _transactions
        }
    }
    
    func loadInvoices() async {
        let _invoices = await interactor.getInvoices(
            from: Date().before(monthes: 3),
            to: Date()
        )
     
        
        await MainActor.run {
            self.invoices = _invoices
        }
    }
}
