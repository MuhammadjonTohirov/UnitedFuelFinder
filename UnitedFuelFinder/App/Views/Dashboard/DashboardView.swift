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
    @State var showAlltrans: Bool = false
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
            
            HStack {
                Text("Transferring transactions")
                Spacer()
                Button(action: {
                    showAlltrans.toggle()
                }, label: {
                    Text("View all")
                })
            }
            ForEach(0..<2) {_ in 
                TransactionView(title: "TRN12938", location: "PILOT BURBANK 287", gallon: 73.02, totalSum: 300, savedAmount: 34.21, price: 4.11, driver: "Aliev Vali", cardNumber: "•••• 1232", date: "12:00 10.11.2023")
            }
            
            HStack {
                Text("Populated invoices")
                Spacer()
                Button(action: {
                    
                }, label: {
                    Text("View all")
                })
            }
            
            ForEach(0..<2) {_ in
                InvoicesView(invoice: "INV-37869", amount: 500.2, secoundAmount: 124, companyName: "JK CARGO INC", date: "12:00 10.11.2023")
                    .padding(.bottom)
            }
            
//            Text("")
//                .frame(height: 50)
        }
        .navigationDestination(isPresented: $showAlltrans, destination: {
            AllTransactionsView()
        })
        .padding(.horizontal)
        .font(.system(size: 14))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .navigationTitle("Dahsboard")
        .navigationBarTitleDisplayMode(.inline)
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
