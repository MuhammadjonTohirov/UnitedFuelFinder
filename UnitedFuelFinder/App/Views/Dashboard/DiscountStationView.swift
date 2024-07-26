//
//  DiscountStationView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 11/02/24.
//

import SwiftUI

struct DiscountStationView: View {
    @State var title: String
    @State var location: String
    @State var price: Float
    @State var discount: Float
    
    var body: some View {
            ZStack {
                Rectangle()
                    .foregroundStyle(.appSecondaryBackground)
                    .cornerRadius(12)
                    .shadow(color: Color.white.opacity(0.2), radius: 4, x: 0, y: 2)
                
                VStack(spacing: 35) {
                    HStack(spacing: 10) {
                       Image("image_ta")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 44, height: 32)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(title)
                            Text(location)
                        }
                        .font(.lato(size: 12))
                        .foregroundStyle(.gray)

                        Spacer()
                        
                        let discountedPrice = price - discount
                        
                        Text("$\(String(format: "%g", discountedPrice))")
                            .font(.lato(size: 12))
                            .fontWeight(.semibold)
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Save ")
                            + Text("$\(String(format: "%g", discount)) ").foregroundColor(Color.accentColor)
                            + Text("per gallon")
                            
                            Text("Retail price ")
                            + Text("$\(String(format: "%g", price))").foregroundColor(Color.accentColor)
                        }
                        .font(.lato(size: 12))
                        .fontWeight(.regular)
                        
                        Spacer()
                        
                        Button(action: {
                            
                        }, label: {
                            HStack {
                                Icon(systemName: "smallcircle.filled.circle")
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 12, height: 12)
                                
                                Text("Focus")
                            }
                            .font(.lato(size: 12))
                            .fontWeight(.medium)
                        })
                        .foregroundStyle(Color.white)
                        .frame(width: 73, height: 26)
                        .background(Color.accentColor)
                        .cornerRadius(4)
                    }
                    .padding(.horizontal)
                }
                .foregroundColor(.black)
            }
            .frame(width: 325, height: 120)
            .edgesIgnoringSafeArea(.vertical)
    }
}

#Preview {
    DiscountStationView(title: "TA/Petrol", location: "23.37 ml • NEWARK NJ", price: 5.1, discount: 0.68)
}
