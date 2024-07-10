//
//  TotalSpendingsWidgetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/07/24.
//

import Foundation
import SwiftUI
import Charts

struct TotalSpendingsWidgetView: View {
    @StateObject var viewModel: TotalSpendingsViewModel
    
    private let chartSize = UIScreen.main.bounds.size.width * 0.35
    @State private var selectedCount: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("total.spendings.by.period".localize)
                .shadow(color: Color.appBackground, radius: 2)
                .font(.bold(size: 16))
            innerBody
                .padding(.trailing, Padding.medium)
                .padding(.vertical, Padding.small)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(.appSecondaryBackground)
                }
        }.onAppear {
            viewModel.loadData()
        }
    }
    
    var innerBody: some View {
        HStack {
            if #available(iOS 17.0, *) {
                chartView
            } else {
                PieView(slices: viewModel.pieData, selected: viewModel.selected)
                    .frame(width: chartSize, height: chartSize)
            }
            
            VStack(spacing: 16) {
                ForEach(viewModel.data) { item in
                    HStack(spacing: 5.0) {
                        selectCircle(
                            color: item.color,
                            selected: viewModel.selected == item.id
                        )
                        Text(item.title)
                            .font(.regular(size: 14))
                        Spacer()
                        Text("$\(item.value.asFloat.asMoney)")
                            .multilineTextAlignment(.trailing)
                            .font(.regular(size: 14))
                    }.onTapGesture {
                        withAnimation {
                            self.viewModel.selected = item.id
                        }
                    }
                }
            }
        }
        .background(Color.clear)
    }
    
    
    @available(iOS 17.0, *)
    @ViewBuilder
    private var chartView: some View {
        if viewModel.pieData.allSatisfy({$0.value == 0}) {
            Text("no.data.available".localize)
                .font(.medium(size: 14))
                .foregroundStyle(.secondary)
                .frame(width: chartSize, height: chartSize)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 8)
        } else {
            Chart(viewModel.pieData) { slice in
                SectorMark(
                    angle: .value("Spendings", slice.value),
                    innerRadius: .ratio(slice.id != viewModel.selected ? 0.6 : 0.5),
                    outerRadius: .ratio(slice.id != viewModel.selected ? 0.8 : 0.9),
                    angularInset: 2
                )
                .cornerRadius(4)
                .foregroundStyle(slice.color)
            }
            .chartAngleSelection(value: $selectedCount)
            .frame(width: chartSize, height: chartSize)
        }
    }
    
    func selectCircle(color: Color, selected: Bool = false) -> some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [color, selected ? .white : color],
                    startPoint: .center,
                    endPoint: .topTrailing
                )
            )
            .frame(width: 15, height: 15)
            .cornerRadius(7.5)
            .shadow(
                color: .black.opacity(selected ? 0.25 : 0),
                radius: selected ? 2 : 0,
                x: 0,
                y: 1
            )
    }
}

#Preview {
    TotalSpendingsWidgetView(viewModel: .test)
}
