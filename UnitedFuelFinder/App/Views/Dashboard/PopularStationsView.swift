//
//  PopularStationsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct PopularStationsView: View {
    let data: [(title: String, value: Int)]
    let defaultColors: [Color] = [.accentColor, .blue, .green]

    var body: some View {
        GeometryReader {geo in
            ZStack {
                Rectangle()
                    .fill(Color.white)
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(alignment: .leading) {
                    ForEach(data.indices, id: \.self) { index in
                        let item = data[index]
                        let color = defaultColors[index % defaultColors.count]
                        VStack(alignment: .leading) {
                            
                            HStack {
                                Text(item.title)
                                    .font(.system(size: 12))
                                    .fontWeight(.regular)
                                  
                                Spacer()
                                
                                Text("#\(item.value)")
                                    .foregroundStyle(Color.black)
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                            }
                            
                            Rectangle()
                                .fill(color)
                                .frame(width: CGFloat(item.value) * 10, height: 8)
                                .cornerRadius(4)
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 143)
    }
    
    init(data: [(title: String, value: Int)]) {
        self.data = data
    }
}

struct ContentView: View {
    let barChartData = [
        (title: "Bar 1", value: 30),
        (title: "Bar 2", value: 10),
        (title: "Bar 3", value: 11)
    ]
    
    var body: some View {
        PopularStationsView(data: barChartData)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
