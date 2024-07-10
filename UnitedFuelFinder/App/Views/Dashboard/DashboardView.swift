//
//  DashboardView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

struct DashboardView: View {
    
    @ObservedObject var viewModel: DashboardViewModel
    @State var headerRect: CGRect = .zero
    
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
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .onAppear {
            self.viewModel.onAppear()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showTransitions = UserSettings.shared.userInfo?.canViewTransactions ?? false
                self.showInvoices = UserSettings.shared.userInfo?.canViewInvoices ?? false
            }
        }
        .coveredLoading(isLoading: $viewModel.isLoading)
    }
    
    var headerView: some View {
        Group {
            switch UserSettings.shared.userInfo?.userType {
            case .company:
                CompanyDashboardHeader(onClickCards: {
                    viewModel.route = .cards
                }, onClickTransactions: {
                    viewModel.route = .transferringStations
                }, onClickInvoices: {
                    viewModel.route = .invoices
                })
                .padding(.top, 20)
            case .driver:
                DriverDashboardHeader()
            default:
                EmptyView()
            }
        }
    }
    
    var innerBody: some View {
        GeometryReader { fullView in
            VStack(alignment: .leading, spacing: 20) {
                headerView
                    .readRect(rect: $headerRect)
                
                AveragesWidgetView()
                
                TotalSpendingsWidgetView(
                    viewModel: viewModel.sepndingsViewModel
                )
                                
                transactionsView.set(isVisible: showTransitions)

                invoicesView.set(isVisible: showInvoices)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .scrollable(showIndicators: false)
            .background {
                Image("image_header")
                    .opacity(0.8)
                    .frame(
                        height: headerRect.height + UIApplication.shared.safeArea.top + 120
                    )
                    .clipped()
                    .offset(y: -fullView.frame(in: .local).height / 2 + fullView.safeAreaInsets.top / 2)
                    .ignoresSafeArea()
            }
        }
    }
    
    private var transactionsView: some View {
        LazyVStack {
            HStack {
                Text("transf.transactions".localize) // Transferring transactions
                    .shadow(color: Color.appBackground, radius: 2)
                    .font(.bold(size: 16))

                Spacer()
                Button(action: {
                    viewModel.navigate(to: .transferringStations)
                }, label: {
                    Text("view.all".localize)
                        .foregroundStyle(.white)
                        .padding(.horizontal, Padding.medium)
                        .padding(.vertical, Padding.small)
                        .background {
                            Capsule()
                                .foregroundStyle(.appDarkGray)
                        }
                })
                .opacity(viewModel.transactions.isEmpty ? 0 : 1)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 120.f.sh())
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        VStack(spacing: 16) {
                            Image(systemName: "list.clipboard")
                            Text("no.transactions".localize)
                                .font(.system(size: 13, weight: .medium))
                        }
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
                    .shadow(color: Color.appBackground, radius: 2)
                    .font(.bold(size: 16))

                Spacer()
                Button(action: {
                    viewModel.navigate(to: .invoices)
                }, label: {
                    Text("view.all".localize)
                        .foregroundStyle(.white)
                        .padding(.horizontal, Padding.medium)
                        .padding(.vertical, Padding.small)
                        .background {
                            Capsule()
                                .foregroundStyle(.appDarkGray)
                        }
                })
                .opacity(viewModel.invoices.isEmpty ? 0 : 1)
            }
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .frame(height: 120.f.sh())
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        VStack(spacing: 16, content: {
                            Image(systemName: "pencil.and.list.clipboard.rtl")
                            Text("no.invoices".localize)
                                .font(.system(size: 13, weight: .medium))
                        })
                    }
                    .opacity(viewModel.invoices.isEmpty ? 1 : 0)
                
                ForEach(viewModel.invoices[0..<3.limitTop(viewModel.invoices.count)]) { invo in
                    InvoiceView(item: invo)
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
    UserSettings.shared.setupForTest()
    return NavigationStack {
        DashboardView(viewModel: .init())
            .navigationBarTitleDisplayMode(.inline)
            .environmentObject(DashboardViewModel())
            .toolbar(content: {
                ToolbarItem(placement: .principal) {
                    Text("dashboard".localize)
                        .font(.bold(size: 16))
                        .foregroundStyle(.white)
                        .shadow(color: .black, radius: 4, x: 0, y: 0)
                }
            })
            .onAppear {
                let appearance = UINavigationBarAppearance()
                appearance.configureWithTransparentBackground()
//
//                let back = UIBarButtonItemAppearance(style: .done)
//                back.normal.backgroundImage = UIImage()
//                
//                back.normal.titlePositionAdjustment = .init(horizontal: -1000, vertical: 0)
//                
//                appearance.backButtonAppearance = back
//                appearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
//                appearance.shadowImage = UIImage()
//                appearance.shadowColor = .clear
//                
                UINavigationBar.appearance().standardAppearance = appearance
//                UINavigationBar.appearance().compactAppearance = appearance
            }
    }
}
