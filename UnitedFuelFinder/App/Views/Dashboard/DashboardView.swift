//
//  DashboardView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

enum DashboardRoute: ScreenRoute {
    var id: String {
        switch self {
        case .transferringStations:
            return "transferringStations"
        case .notifications:
            return "notifications"
        }
    }
    
    case transferringStations
    case notifications
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case .transferringStations:
            AllTransactionsView()
        case .notifications:
            NotificationsView()
        }
    }
}

class DashboardViewModel: ObservableObject {
    @Published var push: Bool = false

    var route: DashboardRoute? {
        didSet {
            push = route != nil
        }
    }
    
    func navigate(to page: DashboardRoute) {
        self.route = page
    }
}

struct DashboardView: View {
    let barChartData = [
        (title: "Bar 1", value: 30),
        (title: "Bar 2", value: 10),
        (title: "Bar 3", value: 11)
    ]
    
    @EnvironmentObject var viewModel: DashboardViewModel
    
    @State var profileImage: String = "station"
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("")
            
            CardWidgetView(name: "John Doe", cardNummber: "•••• 8484", balance: 1500)
            
            Text("total.spendings".localize)
            SpendingsWidgetView()
            
            Text("Most popular station".localize)
            PopularStationsView(data: barChartData)
            
            Text("Top discounted stations".localize)
            stationDetail
            
            HStack {
                Text("Transferring transactions")
                Spacer()
                Button(action: {
                    viewModel.navigate(to: .transferringStations)
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
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .padding(.horizontal)
        .font(.system(size: 14))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
    }
    private var stationDetail: some View {
        HStack{
            ForEach(0..<3) {index in
                DiscountStationView(title: "TA/Petrol", location: "23.37 ml • NEWARK NJ", price: 5.1, discount: 0.68)
                    .background {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundStyle(.appSecondaryBackground)
                    }
            }
        }
        .scrollable(axis: .horizontal, showIndicators: false)
    }
}

#Preview {
    NavigationStack {
        DashboardView()
            .environmentObject(DashboardViewModel())
    }
}
