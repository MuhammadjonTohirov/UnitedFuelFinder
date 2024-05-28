//
//  DashboardView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var showTransitions = false
    @State private var showInvoices = false
    
    @State var profileImage: String = "station"
    
    var body: some View {
        ZStack {
            innerBody
                .background {
                    Rectangle()
                        .foregroundStyle(Color.background)
                }
            
            GeometryReader(content: { geometry in
                VStack(spacing: 0) {
                    Rectangle()
                        .frame(height: geometry.safeAreaInsets.top)
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea()

                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .frame(height: 0)
                }
            })
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
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
            
            transactionsView.set(isVisible: showTransitions)

            invoicesView.set(isVisible: showInvoices)
        }
        .padding(.horizontal)
        .font(.system(size: 14))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showTransitions = UserSettings.shared.userInfo?.canViewTransactions ?? false
                self.showInvoices = UserSettings.shared.userInfo?.canViewInvoices ?? false
            }
        }
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
                .opacity(viewModel.transactions.isEmpty ? 0 : 1)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 120.f.sh())
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        Text("no.transactions".localize)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .opacity(viewModel.transactions.isEmpty ? 1 : 0)
                
                ForEach(viewModel.transactions[0..<3.limitTop(viewModel.transactions.count)]) { tran in
                    TransactionView(item: tran)
                }
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
                .opacity(viewModel.invoices.isEmpty ? 0 : 1)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 120.f.sh())
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        Text("no.invoices".localize)
                            .font(.system(size: 13, weight: .medium))
                    }
                    .opacity(viewModel.invoices.isEmpty ? 1 : 0)
                
                ForEach(viewModel.invoices[0..<3.limitTop(viewModel.invoices.count)]) { invo in
                    InvoiceView(
                        invoice: invo.invoiceNumber ?? "",
                        amount: Float(invo.totalAmount),
                        secoundAmount: Float(invo.totalDiscount ?? 0),
                        companyName: invo.companyAccount?.name ?? "",
                        date: invo.fromToDate
                    )
                }
            }
        }
    }
    
    private var stationDetail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 120.f.sh())
                .foregroundStyle(Color.secondaryBackground)
                .overlay {
                    Text("no.stations".localize)
                        .font(.system(size: 13, weight: .medium))
                }
                .opacity(viewModel.discountedStations.isEmpty ? 1 : 0)
            
            HStack{
                ForEach(viewModel.discountedStations) { station in
                    GasStationItemView(station: station)
                        .set(navigate: { station in
                            viewModel.openStation(station)
                        })
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.appSecondaryBackground)
                        }
                        .onTapGesture {
                            viewModel.navigate(to: .stationInfo(station))                            
                        }
                }
            }
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
        DashboardView(viewModel: .init())
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
