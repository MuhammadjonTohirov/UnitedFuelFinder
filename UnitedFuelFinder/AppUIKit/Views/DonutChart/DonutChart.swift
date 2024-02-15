//
//  DonutChart.swift
//  UnitedFuelFinder
//
//  Created by applebro on 14/02/24.
//

import Foundation
import SwiftUI

struct DonutChartSlice: Identifiable {
    var id = UUID()
    var value: Double
    var color: Color
}

struct DonutChartView: View {
    @State var slices: [DonutChartSlice]
    let holeSize: CGFloat
    
    init(slices: [DonutChartSlice], holeSize: CGFloat = 0.5) {
        self.slices = slices
        self.holeSize = holeSize
    }
    
    var body: some View {
        ZStack {
            ForEach(slices.indices, id: \.f) { index in
                let startAngle = index == 0 ? Angle(degrees: 0) : self.calculateStartAngle(for: index)
                let endAngle = startAngle + self.calculateAngle(for: index)
                
                DonutSlice(
                    startAngle: startAngle,
                    endAngle: endAngle
                )
                .fill(self.slices[index].color)
            }
            Circle()
                .foregroundStyle(.appSecondaryBackground)
                .frame(width: holeSize * 200, height: holeSize * 200)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    private func calculateStartAngle(for index: Int) -> Angle {
        if index == 0 {
            return Angle(degrees: 1)
        } else {
            var totalAngle = Angle(degrees: 1)
            for i in 0..<index {
                totalAngle += calculateAngle(for: i)
            }
            return totalAngle
        }
    }
    
    private func calculateAngle(for index: Int) -> Angle {
        let totalValue = slices.reduce(0) { $0 + $1.value }
        let percentage = slices[index].value / totalValue
        return Angle(degrees: percentage * 360)
    }
}

struct DonutSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.addArc(center: center, radius: radius * 0.5, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        path.closeSubpath()
        
        return path
    }
}
