//
//  CardListView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/07/24.
//

import Foundation
import SwiftUI

struct SelectCardListView: View {
    @Binding var selectedCard: DriverCard?
    var cards: [DriverCard]
    
    var body: some View {
        VStack {
            ForEach(cards, id: \.id) { card in
                VStack(alignment: .leading) {
                    Text(card.name)
                }
                .horizontal(alignment: .leading)
                .padding(10)
                .background(Color.appSecondaryBackground)
                .border(.gray.opacity(0.5), width: 1, cornerRadius: 8)
                .onTapGesture {
                    self.selectedCard = card
                }
                .padding(.horizontal, Padding.medium)
                .padding(.bottom, 8)
            }
        }
        .padding(.top, 20)
    }
}
