//
//  CardWidgetView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

private class CardWidgetModel {
    @codableWrapper(key: "showBalance", false)
    var showCardBalance: Bool?
}

struct CardWidgetView: View {
    @State private var name: String = ""
    @State private var cardNummber: String = ""
    @State private var balance: Double = 0
    private var model: CardWidgetModel = .init()
    @State private var showBalance: Bool = true {
        didSet {
            self.model.showCardBalance = showBalance
        }
    }
    @State private var companyName: String = ""
    
    var body: some View {
        GeometryReader {geo in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(companyName)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    
                    Text(cardNummber)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Divider()
                    .frame(height: 1)
                    .background(.white)
                
                HStack {
                    Text(showBalance ? "\(balance.asFloat.asMoney)" : "******")
                        .font(.system(size: 32.f.sw()))
                    
                    Spacer()
                    Button(action: {
                        showBalance.toggle()
                    }, label: {
                        Rectangle()
                            .frame(width: 32, height: 32)
                            .opacity(0)
                            .overlay(content: {
                                Image(systemName: showBalance ? "eye" : "eye.slash")
                            })
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .fontWeight(.bold)
                
                Text(name)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 143)
        .foregroundStyle(Color.white)
        .background(Color.accentColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        .onAppear { 
            // load card details
            Task {
                let info = await CommonService.shared.fetchCardInfo()
                
                await MainActor.run {
                    self.cardNummber = (UserSettings.shared.userInfo?.cardNumber ?? "0").maskAsMiniCardNumber
                    self.balance = info?.totalBalance ?? 0
                    self.name = info?.accountName ?? ""
                    self.companyName = info?.companyName ?? ""
                }
            }
            
            self.showBalance = self.model.showCardBalance ?? false
        }
    }
}
