//
//  TotalSpendingsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/07/24.
//

import Foundation
import SwiftUI

struct SpendingItem: Identifiable {
    var id: Int
    var value: Double
    var valueString: String
    var title: String
    var color: Color
    
    var pie: PieSlice {
        .init(id: id, value: value, color: color)
    }
}

enum TotalSpendingsFilter: Int, CaseIterable {
    case week = 0
    case week2
    case week3
    
    var title: String {
        switch self {
        case .week:
            return "last.7.days".localize
        case .week2:
            return "last.30.days".localize
        case .week3:
            return "last.90.days".localize
        }
    }
}

final class TotalSpendingsViewModel: ObservableObject {
    @Published var data: [SpendingItem] = []
    @Published var selected: Int = 0
    
    var type: Int {
        filter.rawValue
    }
    
    @Published var isLoading: Bool = false
    @Published var filter: TotalSpendingsFilter = .week
    @Published var showFilterSheet = false
    
    var pieData: [PieSlice] {
        data.map{$0.pie}.sorted(by: {$0.id < $1.id})
    }
    
    func loadData() {
        isLoading = true
        Task {
            let result = await DriverService.shared.summarySpending(type: type)
            let shouldShowDiscountPrice = UserSettings.shared.userInfo?.showDiscountPrices ?? false
            let savings = "$\(result.saving.asFloat.asMoney)"
            await MainActor.run {
                self.data = [
                    .init(id: 0, value: result.spending, valueString: "$\(result.spending.asFloat.asMoney)", title: "spendings".localize, color: .yellow),
                    .init(id: 1, value: shouldShowDiscountPrice ? result.saving : 0, valueString: shouldShowDiscountPrice ? savings : "--", title: "savings".localize, color: .green)
                ]
                isLoading = false
            }
        }
    }
}
