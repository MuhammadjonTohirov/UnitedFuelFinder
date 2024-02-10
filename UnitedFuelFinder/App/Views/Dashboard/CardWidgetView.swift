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
                    
                    Spacer()
                    
                    Text(cardNummber)
                }
                .font(.system(size: 20))
                .fontWeight(.semibold)
                
                Divider()
                    .frame(height: 1)
                    .background(Color(hex: "#FFFFFF"))
                
                HStack {
                    Text(showBalance ? "$ \(balance)" : "******")
                    Spacer()
                    Button(action: {
                        showBalance.toggle()
                    }, label: {
                        Image(systemName: showBalance ? "eye" : "eye.slash")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 16)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .foregroundStyle(Color.white)
                .fontWeight(.bold)
                .font(.system(size: 32))
                
                Text(name)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 143)
        .background(Color(hex: "#FCB527"))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CardWidgetView(name: "John Doe", cardNummber: "•••• 8484", balance: 1500)
}
