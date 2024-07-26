//
//  DriverProperties.swift
//  UnitedFuelFinder
//
//  Created by applebro on 28/06/24.
//

import Foundation
import SwiftUI
import RealmSwift

struct DriverPropertiesView: View {
    @ObservedResults(DCustomer.self, configuration: Realm.config)
    var customers
    
    var userInfo: UserInfo
    
    @State private var cards: [DriverCard] = []
    @State private var selectedStations: Set<Int> = []
    @State private var permissions: [(key: String, val: Bool)] = []
    @State private var selectedCard: DriverCard? {
        didSet {
            selectCard = false
        }
    }
    @State private var isLoading = false
    @State private var selectCard: Bool = false
    @State private var toast: Bool = false
    
    @State private var alert: AlertToast = .init(type: .regular) {
        didSet {
            toast = true
        }
    }
    
    @Environment(\.dismiss)
    private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            fieldSelectView
                .onTapGesture {
                    self.selectCard = true
                }
                .padding(.top, Padding.large)
            Text("dashboard".localize)
                .font(.bold(size: 16))
                .padding(.vertical, 6)
            
            ForEach(permissions, id: \.key) { perm in
                checkbox(perm.key, perm.val).onTapGesture {
                    if let index = self.permissions.firstIndex(where: {$0.key == perm.key}) {
                        var item = permissions[index]
                        item.val.toggle()
                        self.permissions.replace(itemAt: index, with: item)
                    }
                }
            }
            
            Text("stations".localize)
                .font(.bold(size: 16))
                .padding(.top, 10)
            
            stationsView
            
            Spacer()
            
            SubmitButton {
                onClickSave()
            } label: {
                Text("save".localize)
            }
            .padding(.bottom, Padding.medium)
        }
        .toast($toast, alert, duration: 2)
        .scrollBounceBehavior(.basedOnSize)
        .padding(.horizontal, 20)
        .sheet(isPresented: $selectCard, content: {
            SelectCardListView(
                selectedCard: $selectedCard,
                cards: cards
            )
            .dynamicSheet()
            .scrollable()
        })
        .onChange(of: selectedCard, perform: { value in
            self.selectCard = false
        })
        .navigationTitle(userInfo.fullName)
        .onAppear {
            isLoading = true
            permissions = [
                ("view_invoices".localize, userInfo.canViewInvoices),
                ("view_transactions".localize, userInfo.canViewTransactions),
                ("shown_discount_prices".localize, userInfo.showDiscountPrices),
                ("shown_discounted_prices".localize, userInfo.showDiscountedPrices)
            ]
            
            selectedStations = Set(userInfo.includeStations?.compactMap({Int($0)}) ?? [])
            
            selectedCard = .init(
                id: userInfo.cardNumber,
                name: userInfo.driverUnit ?? ""
            )
            Task {
                let cards = await CompanyService.shared.loadDriverCards()
                
                await MainActor.run {
                    self.cards = cards
                    if selectedCard?.name.nilIfEmpty == nil {
                        self.selectedCard = .init(id: "", name: "no.card.selected".localize)
                    }
                    isLoading = false
                }
            }
        }
        .coveredLoading(isLoading: $isLoading)
    }
    
    private var stationsView: some View {
        HStack(spacing: 14) {
            ForEach(customers) { cust in
                FilteringStationView(
                    logo: cust.iconUrl ?? "",
                    title: cust.name,
                    isSelected: selectedStations.contains(cust.id)
                )
                .onTapGesture {
                    if self.selectedStations.contains(cust.id) {
                        self.selectedStations.remove(cust.id)
                    } else {
                        self.selectedStations.insert(cust.id)
                    }
                }
            }
            .frame(width: 100, height: 126)
            .padding(2)
        }
        .scrollable(axis: .horizontal)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }
    
    private var fieldSelectView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("account.cards".localize)
                .font(.medium(size: 16))
            
            HStack(spacing: 10) {
                Text(selectedCard?.name ?? "")
                    .lineLimit(1)
                    .font(.medium(size: 13))
                Spacer()
                
                Icon(systemName: "chevron.down")
            }
            .padding(14)
            .border(.gray, cornerRadius: 8)
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.appBackground)
        }
    }
    
    private func checkbox(_ title: String, _ isSelected: Bool) -> some View {
        HStack(alignment: .center, spacing: 5) {
            Icon(systemName: isSelected ? "checkmark.square.fill" : "square")

            Text(title)
                .font(.regular(size: 12))
        }
    }
    
    func onClickSave() {
        guard let selectedCard, let userId = userInfo.id?.nilIfEmpty else {
            return
        }
        self.isLoading = true
        Task {
            let result = await CompanyService.shared.saveDriverSettings(
                id: userId,
                req: .init(
                    cardNumber: selectedCard.id,
                    driverUnit: selectedCard.name,
                    stations: Array(selectedStations),
                    viewInvoices: permissions[0].val,
                    viewTransactions: permissions[1].val,
                    shownDiscountPrices: permissions[2].val,
                    shownDiscountedPrices: permissions[3].val
                )
            )
            
            await MainActor.run {
                self.isLoading = false
                if !result.success {
                    showError(result.error ?? "unknown_error".localize)
                } else {
                    showSuccess("saved".localize)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        dismiss.callAsFunction()
                    }
                }
            }
        }
    }
    
    private func showError(_ error: String) {
        self.alert = .init(
            displayMode: .alert,
            type: .error(.init(uiColor: .systemRed)),
            title: error
        )
    }
    
    private func showSuccess(_ message: String) {
        self.alert = .init(
            displayMode: .alert,
            type: .error(.init(uiColor: .systemGreen)),
            title: message
        )
    }
}

#Preview {
    return DriverPropertiesView(userInfo: UserInfo(
        id: UUID().uuidString,
        firstName: "Media",
        lastName: "Parker",
        email: "media.parker@mail.uz",
        phone: "935852415",
        cardNumber: "1234 1234 1234 1234",
        companyId: 1,
        companyName: "Company", address: "address",
        cityId: 2,
        cityName: "City",
        state: "State", stateId: "1", stateName: "StateName", confirmed: true, deleted: false,
        permissionList: [
            "view_invoices",
            "view_transactions",
            "shown_discount_prices",
            "shown_discounted_prices"
        ], registerTime: nil, driverUnit: nil, accountId: nil, accountName: nil, role: "", stations: [
            "1",
            "3",
            "4"
        ])
    )
}
