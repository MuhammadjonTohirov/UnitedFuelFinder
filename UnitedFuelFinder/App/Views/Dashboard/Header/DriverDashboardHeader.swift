//
//  CardWidgetView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

class DashboardHeaderViewModel {
    @codableWrapper(key: "showBalance", false)
    var showCardBalance: Bool?
}

struct DriverDashboardHeader: View {
    @State private var name: String = ""
    @State private var cardNummber: String = ""
    @State private var balance: Double = 0
    private var model: DashboardHeaderViewModel = .init()
    
    @State private var showBalance: Bool = true {
        didSet {
            self.model.showCardBalance = showBalance
        }
    }
    @State private var companyName: String = ""
    
    var body: some View {
        LargeCardItemView(
            card: .init(
                companyName: companyName,
                cardNumber: cardNummber,
                accountName: name,
                totalBalance: balance,
                color: "#FFD401"
            ),
            foregroundColor: .black,
            balanceVisible: showBalance,
            onClickEye: {
                self.showBalance.toggle()
            }
        )
        .foregroundStyle(.black)
        .onAppear {
            // load card details
            Task {
                let info = await CommonService.shared.fetchCardInfo()
                
                await MainActor.run {
                    self.cardNummber = UserSettings.shared.userInfo?.cardNumber ?? "0000000000000000"
                    self.balance = info?.totalBalance ?? 0
                    self.name = info?.accountName.nilIfEmpty ?? UserSettings.shared.userInfo?.fullName ?? ""
                    self.companyName = info?.companyName ?? ""
                }
            }
            
            self.showBalance = self.model.showCardBalance ?? false
        }
    }
}

#Preview {
    DriverDashboardHeader()
}
