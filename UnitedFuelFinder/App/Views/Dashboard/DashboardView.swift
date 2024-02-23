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
    
    @EnvironmentObject var viewModel: DashboardViewModel
    
    @State var profileImage: String = "station"
    
    var body: some View {
        ZStack {
            innerBody
                .background {
                    Rectangle()
                        .foregroundStyle(Color.init(uiColor: .systemBackground))
                }
            
            GeometryReader(content: { geometry in
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: geometry.safeAreaInsets.top)
                        .foregroundStyle(Color.init(uiColor: .systemBackground))
                        .ignoresSafeArea()

                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundStyle(Color.init(uiColor: .systemBackground))
                        .ignoresSafeArea(.container, edges: .bottom)
                        .frame(height: 0)
                }
            })
        }
        .onAppear {
            self.viewModel.onAppear()
        }
        .coveredLoading(isLoading: $viewModel.isLoading)
    }
    
    var innerBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            CardWidgetView()
            
            Text("total.spendings".localize)
            SpendingsWidgetView()
            
            Text("popular.stations".localize)
            PopularStationsView(data: barChartData)
            
            Text("discounted.stations".localize)
            stationDetail
            
            if (UserSettings.shared.userInfo?.canViewTransactions ?? false) {
                transactionsView
            }
            
            if (UserSettings.shared.userInfo?.canViewInvoices ?? false) {
                invoicesView
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
    
    private var transactionsView: some View {
        LazyVStack {
            HStack {
                Text("transf.transactions".localize) // Transferring transactions
                Spacer()
                Button(action: {
                    viewModel.navigate(to: .transferringStations)
                }, label: {
                    Text("view.all".localize)
                })
            }
            
            ForEach(viewModel.transactions[0..<3.limitTop(viewModel.transactions.count)]) { tran in
                TransactionView(item: tran)
            }
        }
    }
    
    private var invoicesView: some View {
        LazyVStack {
            HStack {
                Text("popul.invoices".localize)
                Spacer()
                Button(action: {
                    viewModel.navigate(to: .invoices)
                }, label: {
                    Text("view.all".localize)
                })
            }
            
            ForEach(viewModel.invoices[0..<3.limitTop(viewModel.invoices.count)]) { invo in
                InvoicesView(
                    invoice: invo.invoiceNumber ?? "",
                    amount: Float(invo.totalAmount),
                    secoundAmount: Float(invo.totalDiscount ?? 0),
                    companyName: invo.companyAccount?.organization.name ?? "",
                    date: invo.beatufiedDate
                )
              }
        }
    }
    
    private var stationDetail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 120.f.sh())
                .foregroundStyle(Color.secondaryBackground)
                .overlay {
                    Text("no.stations.around".localize)
                        .font(.system(size: 13, weight: .medium))
                }
                .opacity(viewModel.discountedStations.isEmpty ? 1 : 0)
            
            HStack{
                ForEach(viewModel.discountedStations) { station in
                    GasStationItemView(station: station)
                        .set(navigate: { station in
                            viewModel.openStation(station)
                        })
                        .frame(height: 120.f.sh())
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.appSecondaryBackground)
                        }
                }
            }
            .frame(height: 120.f.sh())
            .scrollable(
                axis: .horizontal,
                showIndicators: false
            )
        }
    }
}

#Preview {
    UserSettings.shared.accessToken = UserSettings.testAccessToken
    return NavigationStack {
        DashboardView()
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(DashboardViewModel())
            .navigationTitle("Dashboard")
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
                
                let back = UIBarButtonItemAppearance(style: .done)
                back.normal.backgroundImage = UIImage()
                
                back.normal.titlePositionAdjustment = .init(horizontal: -1000, vertical: 0)
                
                appearance.backButtonAppearance = back
                appearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
                appearance.shadowImage = UIImage()
                appearance.shadowColor = .clear
                
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().compactAppearance = appearance
            }
    }
}
