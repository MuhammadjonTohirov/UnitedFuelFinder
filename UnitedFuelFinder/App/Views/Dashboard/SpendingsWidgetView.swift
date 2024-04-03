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
        .init(uiColor: .systemGreen),
        .init(uiColor: .systemYellow),
        .init(uiColor: .systemOrange),
        .init(uiColor: .systemMint),
        .init(uiColor: .systemBrown)
    ]
    
    @State private var isLoading: Bool = false
    @State private var selectyionType: TotalSpendingFilterType = .today
    @State private var result: TotalSpendings?
    
    var body: some View {
        ZStack {
            VStack {
                filterView
                Spacer()
            }
                
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
                
                Spacer()
                
                rightBody
                    .padding(.leading, 40.f.sw())
                    .overlay {
                        ProgressView()
                            .opacity(isLoading ? 1 : 0)
                    }
            }
        }
        .padding(Padding.medium)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.appSecondaryBackground)
        }
        .onAppear {
            loadTotalSpendings(type: self.selectyionType)
        }
    }
    
    private var filterView: some View {
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
    }
    
    private var rightBody: some View {
        VStack(alignment: .trailing, spacing: 0) {
            ForEach(0..<(result?.records.count ?? 0), id: \.self) { i in
                let _info = self.info(at: i)
                companyInfo(
                    color: .init(uiColor: _info.color),
                    name: _info.name,
                    value: _info.value.asFloat.asMoney
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
    
    private func info(at index: Int) -> TotalSpendings.Record {
        let record = result?.records.item(at: index)
        
        return record ?? .init(id: 0, name: "", value: 0)
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
                self.result = .from(res: res, type: type)
                
                slices = self.result?.records.map { record in
                        .init(value: record.value, color: .init(uiColor: record.color))
                } ?? []
                
                isLoading = false
            }
        }
    }
}

#Preview {
    UserSettings.shared.language = .russian
    return SpendingsWidgetView()
        .padding(.horizontal, Padding.large)
}
