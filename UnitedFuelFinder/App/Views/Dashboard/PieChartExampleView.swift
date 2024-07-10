//
//  PieChartExampleView.swift
//  BookstoreStategist
//
//  Created by Karin Prater on 20.07.23.
//

import SwiftUI
import Charts

struct PieSlice: Identifiable {
    var id: Int
    var value: Double
    var color: Color
}

struct PieView: View {
    @State var slices: [PieSlice]
    var selected: Int = 0
    var body: some View {
        Canvas { context, size in
            // Add these lines to display as Donut
            //Start Donut
            let donut = Path { p in
                p.addEllipse(in: CGRect(origin: .zero, size: size))
                p.addEllipse(in: CGRect(x: size.width * 0.25, y: size.height * 0.25, width: size.width * 0.5, height: size.height * 0.5))
            }
            context.clip(to: donut, style: .init(eoFill: true))
            //End Donut
            let total = slices.reduce(0) { $0 + $1.value }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            
            var startAngle = Angle.zero
            for slice in slices {
                let angle = Angle(degrees: 360 * (slice.value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    
                    p.addArc(
                        center: .zero,
                        radius: slice.id == selected ? radius : (radius - 8),
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(slice.color))
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
