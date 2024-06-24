//
//  PieChartExampleView.swift
//  BookstoreStategist
//
//  Created by Karin Prater on 20.07.23.
//

import SwiftUI
import Charts

struct PieView: View {
    @State var slices: [(Double, Color)]
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
            let total = slices.reduce(0) { $0 + $1.0 }
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            var pieContext = context
            pieContext.rotate(by: .degrees(-90))
            let radius = min(size.width, size.height) * 0.48
            let gapSize = Angle(degrees: 5) // size of the gap between slices in degrees
            
            var startAngle = Angle.zero
            for (value, color) in slices {
                let angle = Angle(degrees: 360 * (value / total))
                let endAngle = startAngle + angle
                let path = Path { p in
                    p.move(to: .zero)
                    p.addArc(center: .zero, radius: radius, startAngle: startAngle + Angle(degrees: 5) / 2, endAngle: endAngle, clockwise: false)
                    p.closeSubpath()
                }
                pieContext.fill(path, with: .color(color))
                startAngle = endAngle
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct ChartView: View {
    @State var data:[(Double, Color)]
    @State var spending:Double
    @State var saving:Double
    private let chartSize = UIScreen.main.bounds.size.width * 0.35
    var body: some View {
        HStack(spacing: 15){
            PieView(slices: data)
                .frame(width: chartSize, height: chartSize)
            
            VStack{
                HStack(spacing: 5.0){
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 15, height: 15)
                        .cornerRadius(7.5)
                    Text("Spendings")
                        .font(.regular(size: 14))
                    Spacer()
                }
                HStack(spacing: 5.0){
                    Circle()
                        .fill(Color.green)
                        .frame(width: 15, height: 15)
                        .cornerRadius(7.5)
                    Text("Savings")
                        .font(.regular(size: 14))
                    Spacer()
                }
            }
            VStack(alignment: .trailing){
                Text("$\(String(format: "%.02f", spending))")
                    .multilineTextAlignment(.trailing)
                    .font(.bold(size: 14))
                Text("$\(String(format: "%.02f", saving))")
                    .multilineTextAlignment(.trailing)
                    .font(.bold(size: 14))
            }
            
        }
        .background(Color.clear)
    }
}


@available(macOS 14.0, *)
#Preview {
    var data = [
        (2.0, Color.red),
        (3.0, Color.orange),
        (1.0, Color.green),
        (4.0, Color.indigo),
        (2.0, Color.purple)]
    var view = ChartView(data: data, spending: 455.3, saving: 3454.9)
    return view
}
