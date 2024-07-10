//
//  LargeCardItemView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/07/24.
//

import Foundation
import SwiftUI

struct LargeCardItemView: View {
    let card: CardModelItem
    var foregroundColor: Color = .white
    var balanceVisible: Bool = false
    var onClickEye: () -> () = {}
    
    var body: some View {
        cardItem(card)
    }
    
    private func cardItem(_ card: CardModelItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(card.companyName)
                .font(.bold(size: 20))
                .padding(.bottom, Padding.medium)
            
            Text("balance".localize)
                .font(.medium(size: 14))
                .padding(.bottom, 10)
            // attributed text
            HStack {
                Text(balanceVisible
                     ? card.balanceInfo
                     : AttributedString("******", attributes: .init(
                        [.font: UIFont.systemFont(ofSize: 28, weight: .bold),]
                     )))
                Spacer()
                Image(balanceVisible ? "eye_show" : "eye_hide")
                    .renderingMode(.template)
                    .onTapGesture {
                        onClickEye()
                    }
            }
            .padding(.bottom, Padding.large)
            
            Text(card.cardNumber.maskAsMiniCardNumber)
                .font(.medium(size: 14))
            HStack(alignment: .bottom) {
                Text(card.accountName)
                Spacer()
                Image("icon_chip")
            }
            .font(.medium(size: 14))
        }
        .foregroundStyle(foregroundColor)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(card.uiColor)
        }
    }
}
