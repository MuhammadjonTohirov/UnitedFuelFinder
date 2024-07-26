//
//  AllCardsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/07/24.
//

import Foundation
import SwiftUI

struct AllCardsView: View {
    @State var cards: [CardModelItem] = []
    @State private var isList: Bool = false
    @State private var isLoading: Bool = false
    @State private var invisibleCards: [String] = []
    var body: some View {
        VStack(spacing: 10) {
            ForEach(cards) { card in
                Group {
                    if isList {
                        smallCardItem(card)
                    } else {
                        cardItem(card)
                    }
                }
                    .padding(.horizontal, Padding.default)
            }
        }
        .scrollable()
        .navigationBarTitleDisplayMode(.inline)
        .coveredLoading(isLoading: $isLoading)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Group {
                    if !isList {
                        Icon(systemName: "list.bullet")
                    } else {
                        Image("icon_grid")
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isList.toggle()
                    }
                }
            }
        })
        .navigationTitle("all.cards".localize)
        .onAppear {
            loadCards()
        }
    }
    
    private func loadCards() {
        self.isLoading = true
        Task {
            let _cards = await CompanyService.shared.loadAllCards()
            
            await MainActor.run {
                self.cards = _cards
                self.isLoading = false
                self.invisibleCards = self.cards.filter({!$0.isVisible}).map({$0.cardNumber})
            }
        }
    }
    
    func smallCardItem(_ card: CardModelItem) -> some View {
        var chipItem: some View {
            VStack(alignment: .trailing) {
                Text(card.companyName)
                    .lineLimit(1)
                    .font(.bold(size: 10))
                Image("icon_chip")
                    .frame(width: 24)
                    .padding(.trailing, 4)
            }
            .frame(width: 75)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.top, 4)
            .padding(.bottom, 8)
            .background {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(card.uiColor)
            }
        }
        return HStack {
            chipItem
            VStack(spacing: 5) {
                HStack {
                    Text(card.cardNumber.maskAsMiniCardNumber)
                        .font(.regular(size: 14))
                    Spacer()
                    Text("balace".localize)
                        .font(.bold(size: 12))
                }
                
                HStack {
                    Text(card.accountName)
                        .font(.regular(size: 14))
                    Spacer()
                    Text(card.isVisible ? ("$"+card.totalBalance.asString) : "******")
                        .font(.medium(size: 14))
                }
            }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(Color.secondaryBackground)
        }
    }
    
    func cardItem(_ card: CardModelItem) -> some View {
        LargeCardItemView(card: card, balanceVisible: !invisibleCards.contains(card.cardNumber)) {
            onCardEyeClicke(card)
        }
    }
    
    private func onCardEyeClicke(_ card: CardModelItem) {
        @codableWrapper(key: card.isVisibleStorageKey, true)
        var isCardVisible: Bool?

        isCardVisible?.toggle()
        
        invisibleCards = self.cards.filter({!$0.isVisible}).map({$0.cardNumber})
    }
}

#Preview {
    NavigationStack {
        AllCardsView()
    }
}

extension CardModelItem: Identifiable {
    public var id: String { self.cardNumber }
    var balanceInfo: AttributedString {
        self.totalBalance.asFloat.asMoneyBeautiful
    }
    
    var uiColor: Color {
        Color(uiColor: .init(hexString: self.color ?? "#EF6630"))
    }
    
    var isVisible: Bool {
        get {
            @codableWrapper(key: isVisibleStorageKey)
            var visible: Bool?
            return visible ?? true
        }
    }
    
    var isVisibleStorageKey: String {
        "card_price_visible\(cardNumber)"
    }
}
