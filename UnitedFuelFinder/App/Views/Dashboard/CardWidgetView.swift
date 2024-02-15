//
//  CardWidgetView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 10/02/24.
//

import SwiftUI

struct CardWidgetView: View {
    @State var name: String
    @State var cardNummber: String
    @State var balance: Int
    @State var showBalance: Bool = true
    var body: some View {
        GeometryReader {geo in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Enregy trucking".localize)
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                    
                    Text(cardNummber)
                        .font(.system(size: 14, weight: .semibold))
                }
                
                Divider()
                    .frame(height: 1)
                    .background(.white)
                
                HStack {
                    Text(showBalance ? "$ \(balance)" : "******")
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
    }
}

#Preview {
    CardWidgetView(name: "John Doe", cardNummber: "•••• 8484", balance: 1500)
}
