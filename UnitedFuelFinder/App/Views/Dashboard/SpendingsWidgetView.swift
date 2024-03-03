//
//  SpendingsWidgetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 13/02/24.
//

import Foundation
import SwiftUI

struct SpendingsWidgetView: View {
    @State
    private var slices: [DonutChartSlice] = []
    
    private var colors: [Color] = [
        .accentColor,
        .init(uiColor: .systemBlue),
        .init(uiColor: .systemGreen)
    ]
    
    @State private var isLoading: Bool = false
    @State private var selectyionType: TotalSpendingFilterType = .today
    @State private var result: TotalSpendings?
    
    var body: some View {
        HStack {
            DonutChartView(slices: slices, holeSize: 0.4)
                .frame(width: 113, height: 113)
                .overlay {
                    Text(result?.total.asFloat.asMoney ?? "$0")
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15, weight: .medium))
                        .frame(width: 65, height: 65, alignment: .center)
                }
                .overlay {
                    ProgressView()
                        .opacity(isLoading ? 1 : 0)
                }
            
            rightBody
                .padding(.leading, 40.f.sw())
                .overlay {
                    ProgressView()
                        .opacity(isLoading ? 1 : 0)
                }
        }
        .padding(Padding.medium)
        .frame(height: 147)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.appSecondaryBackground)
        }
        .onAppear {
            loadTotalSpendings(type: self.selectyionType)
        }
    }
    
    private var rightBody: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack {
                Spacer()
                
                Text("today".localize)
                    .foregroundStyle(color(forType: .today))
                    .onTapGesture {
                        onSelect(type: .today)
                    }
                
                Text("week".localize)
                    .foregroundStyle(color(forType: .week))
                    .onTapGesture {
                        onSelect(type: .week)
                    }
                
                Text("month".localize)
                    .foregroundStyle(color(forType: .month))
                    .onTapGesture {
                        onSelect(type: .month)
                    }
            }
            .font(.system(size: 12, weight: .semibold))
            .padding(.bottom, Padding.default)
            
            ForEach(0..<(result?.records.count ?? 0), id: \.self) { i in
                companyInfo(
                    color: colors[i],
                    name: info(at: i).title,
                    value: info(at: i).value.asMoney
                )
                .padding(.bottom, Padding.small)
            }
            
            Spacer()
        }
    }
    
    private func onSelect(type: TotalSpendingFilterType) {
        guard selectyionType != type, !isLoading else {
            return
        }
        
        self.selectyionType = type
        self.loadTotalSpendings(type: type)
    }
    
    private func info(at index: Int) -> (title: String, value: Float) {
        guard let result else {
            return ("", 0)
        }
        let keys = result.records.keys
        
        if keys.isEmpty {
            return ("", 0)
        }
        
        let key = Array(keys)[index]
        return (key, Float(result.records[key] ?? 0))
    }
    
    private func color(forType type: TotalSpendingFilterType) -> Color {
        type == selectyionType ? .accent : .label
    }
    
    private func companyInfo(color: Color, name: String, value: String) -> some View {
        HStack {
            Circle()
                .foregroundStyle(color)
                .frame(width: 8, height: 8, alignment: .center)
            
            Text(name)
                .font(.system(size: 12))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 12))
        }
    }
    
    private func loadTotalSpendings(type: TotalSpendingFilterType) {
        isLoading = true
        Task {
            let res = await CommonService.shared.fetchTotalSpending(type: type.rawValue)
            
            await MainActor.run {
                self.result = TotalSpendings(
                    type: self.selectyionType,
                    total: res.total,
                    records: res.records
                )
                
                slices = [
                    .init(value: info(at: 0).value.asDouble, color: colors[0]),
                    .init(value: info(at: 1).value.asDouble, color: colors[1]),
                    .init(value: info(at: 2).value.asDouble, color: colors[2])
                ]
                
                isLoading = false
            }
        }
    }
}
