//
//  DashboardViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/02/24.
//

import Foundation
import SwiftUI

enum DashboardRoute: ScreenRoute {
    var id: String {
        switch self {
        case .transferringStations:
            return "transferringStations"
        case .notifications:
            return "notifications"
        }
    }
    
    case transferringStations
    case notifications
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .transferringStations:
            AllTransactionsView()
        case .notifications:
            NotificationsView()
        }
    }
}

class DashboardViewModel: ObservableObject {
    @Published var push: Bool = false
    private(set) var interactor: (any DashboardInteractorProtocol)
    @Published var transactions: [TransactionItem] = []
    
    init(interactor: any DashboardInteractorProtocol = DashboardInteractor()) {
        self.interactor = interactor
    }

    var route: DashboardRoute? {
        didSet {
            push = route != nil
        }
    }
    
    func navigate(to page: DashboardRoute) {
        self.route = page
    }
    
    func reloadData() {
        Task {
            let _transactions = await interactor.getTransactions(
                from: Date().before(monthes: 3),
                to: Date()
            )
         
            
            await MainActor.run {
                self.transactions = _transactions
            }
        }
    }
}
