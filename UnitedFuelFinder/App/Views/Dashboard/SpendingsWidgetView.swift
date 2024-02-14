//
//  SpendingsWidgetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 13/02/24.
//

import Foundation
import SwiftUI

struct SpendingsWidgetView: View {
    let slices: [DonutChartSlice] = [
        DonutChartSlice(value: 0.5, color: .accentColor),
        DonutChartSlice(value: 0.3, color: .init(uiColor: .systemBlue)),
        DonutChartSlice(value: 0.2, color: .init(uiColor: .systemGreen)),
    ]
    
    var body: some View {
        HStack {
            DonutChartView(slices: slices, holeSize: 0.4)
                .frame(width: 113, height: 113)
                .overlay {
                    Text("$1200")
                        .font(.system(size: 16, weight: .semibold))
                }
            
            rightBody
                .padding(.leading, 40.f.sw())
        }
        .padding(Padding.medium)
        .frame(height: 147)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.appSecondaryBackground)
        }
    }
    
    private var rightBody: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack {
                Text("today".localize)
                    .foregroundStyle(.accent)
                
                Text("week".localize)
                Text("month".localize)
            }
            .font(.system(size: 13, weight: .semibold))
            .padding(.bottom, Padding.default)
            
            companyInfo(color: .accentColor, name: "TA/Petro", value: "$150")
                .padding(.bottom, Padding.small)
            companyInfo(color: .init(uiColor: .systemGreen), name: "AB/Petro", value: "$900")
                .padding(.bottom, Padding.small)
            companyInfo(color: .init(uiColor: .systemBlue), name: "CD/Petro", value: "$350")
                .padding(.bottom, Padding.small)
            
            Spacer()
        }
    }
    
    private func companyInfo(color: Color, name: String, value: String) -> some View {
        HStack {
            Circle()
                .foregroundStyle(color)
                .frame(width: 8, height: 8, alignment: .center)
            
            Text(name)
                .font(.system(size: 13))
            
            Spacer()
            
            Text(value)
                .font(.system(size: 13))
        }
    }
}

#Preview {
    SpendingsWidgetView()
}
