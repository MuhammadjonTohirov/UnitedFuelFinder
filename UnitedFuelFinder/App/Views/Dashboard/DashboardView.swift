//
//  DashboardView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

struct DashboardView: View {
    let barChartData = [
        (title: "Bar 1", value: 30),
        (title: "Bar 2", value: 10),
        (title: "Bar 3", value: 11)
    ]
    
    @State var profileImage: String = "station"
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("")
            
            CardWidgetView(name: "John Doe", cardNummber: "•••• 8484", balance: 1500)
            
            Text("Most popular station".localize)
            PopularStationsView(data: barChartData)
            
            Text("Top discounted stations".localize)
            stationDetail
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal)
        .font(.system(size: 14))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .navigationTitle("Dahsboard")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "bell")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.init(uiColor: .label))
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                Image(profileImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
                    .cornerRadius(20)
            }
        }
    }
    private var stationDetail: some View {
        ZStack {
            HStack{
                ForEach(0..<3) {index in
                    DiscountStationView(title: "TA/Petrol", location: "23.37 ml • NEWARK NJ", price: 5.1, discount: 0.68)
                }
            }
            .scrollable(axis: .horizontal, showIndicators: false)
        }
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
}
