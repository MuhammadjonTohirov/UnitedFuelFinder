//
//  AveragesWidgetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/07/24.
//

import Foundation
import SwiftUI

struct AveragesWidgetView: View {
    @State private var data: (savings: Float, gallons: Float, discount: Float) = (0,0,0)
    var body: some View {
        HStack {
            item(
                title: "total.savings".localize,
                detail: Text("$ \(data.savings.asMoney)")
                    .foregroundStyle(Color.green)
                    .font(.bold(size: 20))
                    .anyView
            )
            Spacer()
            item(
                title: "total.gallons".localize,
                detail: Text(data.gallons.asMoney)
                    .font(.bold(size: 20))
                    .anyView
            )
            Spacer()
            item(
                title: "discount".localize,
                detail: Text("$ \(data.discount.asMoney)")
                    .font(.bold(size: 20))
                    .anyView
            )
        }
        .padding(Padding.medium)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.appSecondaryBackground)
        }
        .onAppear {
            Task {
                let savings = await DriverService.shared.totalSavings()
                let gallons = await DriverService.shared.totalGallons()
                let discount = await DriverService.shared.meanDiscount()
                
                await MainActor.run {
                    self.data = (savings, gallons, discount)
                }
            }
        }
    }
    
    private func item(title: String, detail: AnyView) -> some View {
        VStack(alignment: .leading, spacing: 35) {
            Text(title)
                .font(.semibold(size: 12))
            detail
        }.padding(.vertical, Padding.medium)
    }
}

#Preview {
    AveragesWidgetView()
}
