//
//  PopularStationsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct PopularStationsView: View {
    @State private var data: [(title: String, value: Int, color: Color)] = [
        
    ]
    
    @State private var popularStations: PopularStations?
    
    @State private var barSize: CGRect = .init(x: 0, y: 0, width: 1, height: 1)
    @State private var isLoading = false
    var body: some View {
        GeometryReader {geo in
            ZStack {
                Rectangle()
                    .foregroundStyle(.appSecondaryBackground)
                    .cornerRadius(12)
                
                VStack(alignment: .leading) {
                    ForEach(data.indices, id: \.self) { index in
                        let item = data[index]
                        let color = data[index].color
                        VStack(alignment: .leading) {
                            HStack {
                                Text(item.title)
                                    .font(.lato(size: 12))
                                    .fontWeight(.regular)
                                
                                Spacer()
                                
                                Text("#\(item.value)")
                                    .font(.lato(size: 12))
                                    .fontWeight(.semibold)
                            }
                            Rectangle()
                                .frame(height: 8)
                                .cornerRadius(4)
                                .foregroundStyle(Color.secondaryBackground)
                                .readRect(rect: $barSize)
                                .overlay {
                                    HStack {
                                        Rectangle()
                                            .fill(color)
                                            .frame(
                                                width: CGFloat(item.value) * barSize.width / CGFloat(popularStations?.total ?? 1),
                                                height: 8
                                            )
                                            .cornerRadius(4)
                                        
                                        Spacer()
                                    }
                                }
                        }
                        .foregroundColor(.label)
                        .padding(.horizontal)
                    }
                }
            }
            .overlay {
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 143)
        .onAppear {
            isLoading = true
            self.data = []
            
            Task {
                guard let result = await CommonService.shared.fetchPopularStations(size: 3) else {
                    return
                }
                
                await MainActor.run {
                    self.data = []
                    self.popularStations = PopularStations(
                        total: result.total,
                        rows: result.rows.map({
                            PopularStationItem(
                                id: $0.id,
                                customerName: $0.customer,
                                station: $0.station,
                                value: $0.value
                            )
                        })
                    )
                    
                    self.popularStations?.rows.forEach { item in
                        self.data.append(
                            (
                                "\(item.customerName) \(item.station)",
                                item.value,
                                .init(uiColor: item.customer?.colorCode ?? .label)
                            )
                        )
                    }
                    
                    isLoading = false
                }
            }
        }
    }
    
    init(data: [(title: String, value: Int, color: Color)]) {
        self.data = data
    }
}

struct ContentView: View {
    let barChartData = [
        (title: "Bar 1", value: 30, color: Color.red),
        (title: "Bar 2", value: 10, color: .red),
        (title: "Bar 3", value: 11, color: .red)
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
