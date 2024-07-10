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
    var title: String
    var color: Color
    
    var pie: PieSlice {
        .init(id: id, value: value, color: color)
    }
}

final class TotalSpendingsViewModel: ObservableObject {
    @Published var data: [SpendingItem] = []
    @Published var selected: Int = 0
    @Published var type: Int = 0
    @Published var isLoading: Bool = false
    
    var pieData: [PieSlice] {
        data.map{$0.pie}.sorted(by: {$0.id < $1.id})
    }
    
    func loadData() {
        isLoading = true
        Task {
            let result = await DriverService.shared.summarySpending(type: type)
            await MainActor.run {
                self.data = [
                    .init(id: 0, value: result.spending, title: "spendings".localize, color: .green),
                    .init(id: 1, value: result.saving, title: "savings".localize, color: .yellow)
                ]
                isLoading = false
            }
        }
    }
}

extension TotalSpendingsViewModel {
    static var test: TotalSpendingsViewModel {
        let model = TotalSpendingsViewModel()
        model.data = [
            .init(id: 0, value: 120, title: "spendings".localize, color: .green),
            .init(id: 1, value: 150, title: "savings".localize, color: .yellow),
        ]
        return model
    }
}
