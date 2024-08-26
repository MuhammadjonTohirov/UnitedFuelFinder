//
//  CompanyDashboardHeader.swift
//  UnitedFuelFinder
//
//  Created by applebro on 05/07/24.
//

import Foundation
import SwiftUI

struct CompanyDashboardHeader: View {
    var onClickCards: () -> () = {}
    var onClickTransactions: () -> () = {}
    var onClickInvoices: () -> () = {}
    
    init(onClickCards: @escaping () -> Void, onClickTransactions: @escaping () -> Void, onClickInvoices: @escaping () -> Void) {
        self.onClickCards = onClickCards
        self.onClickTransactions = onClickTransactions
        self.onClickInvoices = onClickInvoices
    }
    
    @State private var showBalance = false {
        didSet {
            model.showCardBalance = showBalance
        }
    }
    
    @State private var balance: Double = 0
    private var model: DashboardHeaderViewModel = .init()
    
    var body: some View {
        VStack {
            allBalance
            
            HStack(alignment: .top) {
                actionButton(image: "icon_card32", title: "all.cards".localize)
                    .onTapGesture {
                        self.onClickCards()
                    }
                Spacer()
                actionButton(image: "icon_trans32", title: "recent.transactions".localize)
                    .onTapGesture {
                        self.onClickTransactions()
                    }
                Spacer()
                actionButton(image: "icon_reload32", title: "recent.invoices".localize)
                    .onTapGesture {
                        self.onClickInvoices()
                    }
            }
        }
        .onAppear {
            Task.detached {
                let info = (await CompanyService.shared.loadAllCards()).reduce(0) { $0 + $1.totalBalance }
                
                await MainActor.run {
                    self.balance = info
                    self.showBalance = model.showCardBalance ?? false
                }
            }
        }
    }
    
    private var allBalance: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("all.balance".localize)
                .foregroundStyle(.accent)
                .font(.medium(size: 14))
            
            HStack {
                Text(showBalance ? balance.asFloat.asMoneyBeautiful : "******")
                    .font(.bold(size: 28))
                    .foregroundStyle(.white)
                
                Spacer()
                Image(showBalance ? "eye_show" : "eye_hide")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .clipped()
                    .onTapGesture {
                        showBalance.toggle()
                    }
            }
        }
    }
    
    private func actionButton(image: String, title: String) -> some View {
        VStack(spacing: 5) {
            Circle()
                .frame(width: 55, height: 55)
                .foregroundStyle(.accent)
                .overlay {
                    Image(image)
                }
            Text(title)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.white)
                .font(.medium(size: 14))
                .frame(maxWidth: 100)
        }
    }
}
