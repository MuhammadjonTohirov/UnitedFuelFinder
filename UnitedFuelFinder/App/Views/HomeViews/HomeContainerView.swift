//
//  HomeContainerView.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 06/06/24.
//

import UIKit
import SwiftUI

struct HomeContainerView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        self.viewModel = viewModel
        
    }
    var body: some View {
        ZStack {
            VStack(){
                Icon(systemName: "star.fill")
                    .aspectRatio(contentMode: .fill)
                    .clipped()
                    .background(.red)
            }
            innerBody
                .background {
                    Rectangle()
                        .foregroundStyle(Color.background)
                }
            
        }
        .onAppear {
            self.viewModel.onAppear()
        }
    }
    private var innerBody: some View {
        VStack(alignment: .leading, spacing: 20) {
            //CardWidgetView()
//            TotalSpendingsWidgetView(data: viewModel.chartData, spending: 1, saving: 45)
//                .padding()
//                .background(Color.gray)
//                .cornerRadius(8)
            
            recentTransactionView
            recentInvoicesView
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .padding(.horizontal)
        .font(.lato(size: 14))
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .onAppear {
            
        }
    }
    private var recentTransactionView: some View {
        LazyVStack {
            RecentTransactionView(items: TransactionItem.mockItems())
        }
    }
    private var recentInvoicesView: some View {
        LazyVStack {
            RecentInvoicesView(items: InvoiceItem.mockItems())
        }
    }
    
}

#Preview {
    let view = HomeContainerView(viewModel: .init())
    return view
    //return HomeContainerView(viewModel: .init())
}
