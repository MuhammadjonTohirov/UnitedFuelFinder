//
//  AllTransactionsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 20/02/24.
//

import Foundation

protocol AllTranInvoViewModelProtocol: ObservableObject {
    var transactions: [TransactionItem] {get set}
    var invoices: [InvoiceItem] {get set}
    
    func loadTransactions(from: Date, to: Date) async
}

class AllTranInvoViewModel: AllTranInvoViewModelProtocol {
    @Published var transactions: [TransactionItem] = []
    @Published var invoices: [InvoiceItem] = []
    
    func loadTransactions(from: Date, to: Date) async {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        
        let _transactions = (await CommonService.shared.fetchTransactions(
            fromDate: _from,
            to: _to
        )).compactMap({TransactionItem(from: $0)})

        await MainActor.run {
            self.transactions = _transactions
        }
    }
    
    func loadInvoices(from: Date, to: Date) async {
        let _from = from.toString(format: "ddMMyyyy")
        let _to = to.toString(format: "ddMMyyyy")
        
        let _invoices = (await CommonService.shared.fetchInvoices(
            fromDate: _from,
            to: _to
        )).compactMap({InvoiceItem(from: $0)})

        await MainActor.run {
            self.invoices = _invoices
        }
    }
}
